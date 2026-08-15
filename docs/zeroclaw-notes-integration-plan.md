# Zeroclaw Notes and Task Integration Plan

## Goal

Give Zeroclaw a tightly scoped, durable workspace for personal notes, GTD-style
tasks, and project context. Notes remain directly editable from Android through
Orgzly and WebDAV. The assistant may write directly to the same notes folder,
with Syncthing versioning and Btrfs snapshots providing rollback.

Financial documents are explicitly out of scope and must never be available to
Zeroclaw.

## Current State

- Android Orgzly syncs notes over WebDAV to `dv-pi5`.
- `dv-pi5` synchronizes notes to `dv-desktop` and `dv-fw` through Syncthing.
- Notes and financial documents are already separate filesystem and Syncthing
  folders.
- Zeroclaw runs in an isolated MicroVM on `home-srv` and has no notes access.
- `home-srv` uses Btrfs with separate `@` and `@snapshots` subvolumes, but has
  no configured snapshot service or Syncthing instance.
- The shared Syncthing Home Manager profile currently shares every configured
  folder with every configured peer. Adding `home-srv` without changing that
  behavior would incorrectly sync financial documents to it.

## Target Architecture

```text
Android Orgzly
  -> WebDAV on dv-pi5
  -> notes-only Syncthing folder
  -> /srv/notes (@notes Btrfs subvolume on home-srv)
  -> scoped read/write virtiofs share in vm-zeroclaw
```

`home-srv` becomes a notes-only Syncthing peer and eventually replaces
`dv-pi5` as the always-on notes peer. The Zeroclaw VM receives only the notes
folder through a writable virtiofs mount; it does not run Syncthing, receive
Syncthing credentials, or receive access to the host home directory.

## Data and Access Boundaries

| Data or service | Access |
| --- | --- |
| Personal notes | Android, `dv-pi5`, `dv-desktop`, `dv-fw`, `home-srv`, and Zeroclaw |
| Financial documents | Existing trusted Syncthing peers only; never `home-srv` or Zeroclaw |
| Syncthing device credentials | Syncthing hosts only; never Zeroclaw |
| Btrfs snapshots and Syncthing versions | Host administrators only; not mounted in Zeroclaw |
| Zeroclaw state | Zeroclaw VM only, persisted at `/var/lib/zeroclaw-main` |

The assistant may append captures and update explicitly requested task or
project files. It must not delete, bulk-reorganize, or access financial data
without a future explicit design change.

## Notes Convention

Use the existing Org notes folder with the following initial layout:

```text
notes/
  inbox.org
  tasks.org
  projects/
    <project-slug>/
      project.org
      context.org
      notes.org
```

- `inbox.org`: unprocessed captures from Telegram, the assistant, or manual
  entry.
- `tasks.org`: GTD-style personal tasks with states such as `INBOX`, `NEXT`,
  `WAITING`, `SOMEDAY`, and `DONE`.
- `project.org`: desired outcome, current status, next action, blockers,
  decisions, and project tasks.
- `context.org`: concise handoff context for starting a new Zeroclaw or
  OpenCode session on another machine.
- `notes.org`: supporting research and raw project notes.

The project context is intentionally plain Org data rather than assistant-only
memory, so it remains portable, reviewable, and usable by other tools.

## Recovery Strategy

### Syncthing Versioning

Enable staggered file versioning for the notes folder on `dv-pi5`,
`dv-desktop`, `dv-fw`, and `home-srv`.

Syncthing archives a file when a replacement or deletion is received from a
different peer. It provides convenient per-file restoration, but does not
archive a modification made locally on the same device. Versioning is not a
backup and must not be the only recovery mechanism.

Store Syncthing versions outside the assistant-visible notes mount where
possible.

### Btrfs Snapshots

Create an `@notes` Btrfs subvolume mounted at `/srv/notes` on `home-srv`.
Create snapshots in the existing `@snapshots` subvolume, for example below
`/.snapshots/notes`.

Use **Snapper** initially because it provides local Btrfs snapshot creation,
retention, inspection, and rollback without custom snapshot cleanup code.
Configure a dedicated `notes` Snapper configuration, with no broad root or
home snapshots introduced by this work.

The desired retention intent is:

- A snapshot approximately every 15 minutes for the most recent 48 hours.
- Hourly recovery points for 14 days.
- Daily recovery points for 90 days.
- Monthly recovery points for 12 months.

Validate Snapper's timer granularity and cleanup policy during implementation.
If its timeline scheduling cannot express the 15-minute tier cleanly, use a
small declarative systemd timer to create named Snapper snapshots every 15
minutes, while Snapper performs retention cleanup. Do not create unbounded
snapshots.

Snapshots are local-only protection. A later backup phase should use **btrbk**
or `btrfs send`/`receive` to replicate `@notes` snapshots to another trusted
machine or disk. btrbk is better suited to that future off-host replication
than to the initial local rollback requirement.

## Implementation Steps

### 1. Model Folder Membership Explicitly

Refactor `profiles/sync/home.nix` and the corresponding private Syncthing
definitions so each folder declares its own allowed devices. Preserve current
notes sharing among `dv-pi5`, `dv-desktop`, and `dv-fw`, then add `home-srv`
only to the notes folder.

Do not add `home-srv` to the financial-documents folder. Verify the generated
Syncthing configuration on every existing peer before activation.

### 2. Provision Notes Storage on home-srv

The existing `home-srv` Btrfs layout is mounted declaratively but its
subvolumes are not created declaratively. Perform the following one-time
operation during an approved maintenance window:

1. Mount the Btrfs top-level subvolume temporarily.
2. Create `@notes` as a sibling of the existing `@home`, `@var`, and
   `@snapshots` subvolumes.
3. Configure `/srv/notes` in `machines/home-srv/hardware.nix` with the
   repository's existing Btrfs mount options: `compress=zstd:1`,
   `discard=async`, and `noatime`.
4. Create a dedicated owner/group and directory permissions appropriate for
   the Syncthing service and Zeroclaw's scoped access.

The one-time subvolume creation is stateful and must not be attempted as part
of an ordinary configuration rebuild without an explicit operator action.

### 3. Enable home-srv Notes Synchronization

Configure a Syncthing service on `home-srv` using the existing private device
and folder definitions, but only for the notes folder. Provide a distinct
`home-srv` Syncthing certificate/key through the existing age-secret pattern.

Open only the required Syncthing transport/discovery ports on the trusted LAN
and Tailscale interfaces. Do not expose the Syncthing GUI through Caddy. Keep
the UI local or accessible through authenticated SSH/Tailscale forwarding.

Confirm that the WebDAV-to-`dv-pi5` flow remains unchanged until the planned
migration away from `dv-pi5` is separately designed and tested.

### 4. Configure Versioning and Snapshots

Enable staggered Syncthing versioning only for notes, with a bounded retention
period and host-only version storage.

Install and configure Snapper for `/srv/notes`. Enable scheduled snapshot
creation and cleanup with the retention policy above, monitoring both the
`@notes` and `@snapshots` subvolumes for capacity.

Document restore procedures for:

- A single file from Syncthing versions.
- A single file from a Snapper snapshot.
- The complete notes tree from a Snapper snapshot.

Never make an automatic full-subvolume rollback while Syncthing is running;
pause synchronization and take a safety snapshot first.

### 5. Expose Notes to Zeroclaw

Add a dedicated writable virtiofs share from `/srv/notes` to a fixed guest
mount path such as `/srv/notes`.

Review the upstream Zeroclaw systemd sandbox and extend only the service's
writable-path allowance for that guest mount. Do not weaken unrelated sandbox
controls or mount the host home directory.

Set ownership and permissions so the service can update notes while snapshot
directories, Syncthing configuration, financial documents, and other host
paths remain inaccessible.

### 6. Add Assistant Workflows

Start with direct, auditable file operations:

- Capture a message into `inbox.org`.
- Create a project directory from the template.
- Add or update `NEXT` and `WAITING` actions.
- Update `context.org` at the end of a planning or coding session.
- Summarize active projects, next actions, and waiting work.

For substantive edits, write an Org logbook/property entry identifying the
agent and timestamp. Require an explicit request before deletion or broad
reorganization.

## Verification Checklist

- `home-srv` receives notes but has no financial-documents folder.
- The Zeroclaw guest can read and modify notes but cannot see financial data,
  `.stversions`, snapshots, Syncthing keys, or host home directories.
- An Android Orgzly edit reaches `home-srv`, `dv-desktop`, and `dv-fw`.
- A Zeroclaw edit reaches Android through the existing WebDAV/Syncthing path.
- A remote replacement is recoverable through Syncthing versioning.
- A local `home-srv` modification is recoverable through Snapper.
- Snapshot retention works and free-space monitoring detects growth before the
  Btrfs filesystem becomes constrained.
- The existing `zeroclaw.furfaces.net` private Tailscale/local-network access
  model remains unchanged.

## Deferred Work

- Move the WebDAV service from `dv-pi5` to `home-srv` after the notes peer is
  stable.
- Add an off-host Btrfs replication target with btrbk or `btrfs send`/`receive`.
- Add calendar, Proton Mail, and home-automation integrations after the notes
  and task workflow is reliable.
- Reconsider a Git layer only if file history, collaboration, or structured
  cross-machine project handoffs exceed what Org, Syncthing versioning, and
  Btrfs snapshots provide.

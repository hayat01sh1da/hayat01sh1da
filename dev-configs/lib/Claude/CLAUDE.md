# Workspace Guide

This directory contains multiple independent GitHub repositories owned by `hayat01sh1da` (one git repository per subdirectory; this parent directory itself is not a git repository).  
`spreen-wiki.wiki` is a wiki mirror (of `spreen-wiki`, the repository renamed from `github-wiki-organisers` on 2026-07-13) and `working-report` is empty — exclude both from cross-repo tasks unless explicitly requested.

## 1. Recurring Task

### 1-1. Filling out Pull Request Description according to `.github/PULL_REQUEST_TEMPLATE.md`

When asked to summarise the changes of topic branches in each repository (in any phrasing, e.g. "Summarise the changes of topic branches in each repository according to PR template and export the reports as markdown files under each repository"), do the following:

Trigger phrases (non-exhaustive — match the intent, not the exact words):

- "Summarise the topic branches" — run the full task across all repositories.
- "Summarise the topic branch in `<repo>`" — run the task for that repository only.
- "Regenerate the PR descriptions" / "Update the PR descriptions for the new commits" — re-export the reports after further commits on the branches.

A one-off deviation stated in the same message (different filename, only committed changes, include working-tree changes, etc.) overrides these defaults for that run.

1. For each repository, diff the current topic branch against `master` (`git diff master...HEAD`).
2. Write the summary to `PR_DESCRIPTION.md` at the repository root, following that repository's `.github/PULL_REQUEST_TEMPLATE.md` structure exactly:
   - `## 1. Overview` — prose describing what the branch does and why.
   - `## 2. Key Changes & Differences` — the template's 4-column table
     (`|<Items> |Before |After |Changes & Differences |`). Adapt the first column's noun to the subject of the change (Gems / Libraries / Packages / Workflows / files). One row per changed item, derived from the actual diff.
   - `## 3. Summary` — outcome counts, follow-up actions, and operational notes.
   - `## 4. References` — absolute GitHub URLs to the changed files on the topic branch (`https://github.com/hayat01sh1da/<repo>/blob/<branch>/<path>`) plus relevant docs.
   - Markdown formatting of the prose sections: put each sentence on its own line ending with two trailing whitespaces (`  `, the `<br />` marker), and insert a blank line between passages. This applies to `PR_DESCRIPTION.md` and to PR descriptions posted on GitHub (§ 1-2).
3. Leave `PR_DESCRIPTION.md` untracked — never commit or push unless explicitly asked.
4. Skip repositories whose topic branch has no diff against `master`.

### 1-2. Opening Pull Requests

When explicitly asked to commit, push, and open PRs for work in the repositories, follow these conventions (a one-off deviation stated in the same message overrides them for that run).

Trigger phrases (non-exhaustive — match the intent, not the exact words):

- "Open PRs" / "Open pull requests in each repository" — run the full flow below (branch → commit → push → PR) in every repository with relevant changes.
- "Open a PR in `<repo>`" — run the full flow for that repository only.
- "Commit and push the changes" — create the branch, commit, and push only; do not open PRs.
- "Update the PRs" / "Reflect the new changes in the PRs" — commit and push further changes to the existing topic branches and refresh the PR descriptions.

1. Branch: `hayat01sh1da/<topic>/<kebab-case-summary>` created from `master`
   (e.g. `hayat01sh1da/github-actions/define-reviewers-and-assignees-in-daily-library-dependencies-update`).
2. Commit: one commit per repository containing only the files relevant to the task; message is an imperative sentence matching the branch summary (e.g. "Define reviewers and assignees in daily library dependencies update"). When asked to "commit by semantic unit", split into multiple commits grouped by concern (sources / signatures / tests / docs, etc.) instead.
3. PR title: `[<topic>] <Summary in Title Case>`
   (e.g. `[github-actions] Define Reviewers and Assignees in Daily Library Dependencies Update`).
4. PR description: the same 4-section `.github/PULL_REQUEST_TEMPLATE.md` structure as § 1-1, with References linking the changed files on the topic branch.
5. Reviewers: request `hayat01sh1da`. GitHub rejects this on PRs authored by hayat01sh1da's own token ("Review cannot be requested from pull request author") — skip in that case rather than failing; it only works on PRs authored by someone else (e.g. `github-actions[bot]`).
6. Assignees: `claude[bot]` if assignable. The API silently ignores unassignable users (HTTP 201, bot absent from the returned assignees) — the Claude GitHub App is now installed with access to **All repositories** ([installation 142769614](https://github.com/settings/installations/142769614), confirmed 2026-07-17), yet `claude[bot]` is *still* not assignable — test assignments on merged PRs (`pr-title-printers#96`, `spreen-wiki#125`) were silently ignored on 2026-07-17. This is a GitHub-side limitation (regular App bots are not valid assignees; only special-cased bots are), not a setup gap, so attempting it remains a harmless no-op; `github-actions[bot]` IS assignable even though `GET /repos/.../assignees/{user}` returns 404 for it (that endpoint is unreliable for bot accounts).
7. Base branch is always `master`; cross-repo runs cover every repo with relevant changes and skip the rest.

## 2. Production Release / Publish

### 2-1. RubyGems

Worked example: the `spreen-wiki` gem (sources in `spreen-wiki/RubyGem/`, module `SpreenWiki`, CLI `spreen`), published as [`spreen-wiki`](https://rubygems.org/gems/spreen-wiki) — v0.1.0 pushed manually on 2026-07-13, later releases automated. Copy its files as the canonical templates when publishing another gem.

Trigger phrases (non-exhaustive — match the intent, not the exact words). A tag push publishes immediately once the release workflow exists, so tagging/publishing needs the explicit "release"/"tag" phrasings below; anything vaguer stops at "prepare":

- "Release the RubyGem vX.Y.Z" / "Publish `<name>` vX.Y.Z to RubyGems" — run § 2-1-5 end-to-end: version bump + CHANGELOG re-sectioning on a topic branch and PR (§ 1-2); after that PR merges, push the `ruby-vX.Y.Z` tag (publishes via CI) and cut the GitHub Release.
- "Release vX.Y.Z for both RubyGems and PyPI" — run § 2-1-5 and § 2-2-5 together.
- "Prepare the RubyGem release" — § 2-1-5 step 1 only (bump + CHANGELOG + PR); do not tag.
- "Tag ruby-vX.Y.Z and cut the GitHub Release" — § 2-1-5 steps 2–3 only (for a version already on `master`).
- "Fill in the release description" — write or update a GitHub Release body in the § 2-1-5 format (works on drafts too).
- "Publish `<name>` as a RubyGem" (a new gem) — the full pipeline §§ 2-1-2 → 2-1-4.
- "Set up Trusted Publishing for `<name>`" — § 2-1-4 only.

#### 2-1-1. One-time setup (per account)

- Account at `https://rubygems.org` with MFA set to `UI and API`; `gem signin` locally (WSL).

#### 2-1-2. Packaging a new gem

- Verify the name is unclaimed (`gem search -r <name>` and the rubygems.org page) before committing to it.
- Flat module namespace (`FooBar`, not `Foo::Bar`), sources under `lib/<foo_bar>/`; if the gem name is dashed (`foo-bar`), add a shim `lib/foo-bar.rb` that requires `foo_bar` so both `require` paths work.
- Gemspec essentials: `version` read from `lib/<foo_bar>/version.rb`; `required_ruby_version`; `metadata` for homepage/source/changelog/bug-tracker URIs and `rubygems_mfa_required: 'true'`; explicit `files` list including any data files (templates); `bindir = 'exe'` + `executables` for CLIs.
- Ship `README.md`, `LICENSE.txt`, `CHANGELOG.md` (Keep a Changelog, numbered headings), RBS signatures in `sig/`.

#### 2-1-3. First publish (manual)

- `gem build <name>.gemspec` → install the built gem locally and smoke-test the CLI/`require` → `gem push <name>-X.Y.Z.gem`.

#### 2-1-4. Automate releases with Trusted Publishing (OIDC, no API keys)

1. Register the publisher at `https://rubygems.org/gems/<name>/trusted_publishers`: GitHub Actions, repository owner/name, workflow filename `rubygem--release.yml`, environment optional.
2. Rakefile: `require 'bundler/gem_helper'` + `Bundler::GemHelper.install_tasks` to define `rake release`. In a repo hosting multiple packages, set `Bundler::GemHelper.tag_prefix = 'ruby-'` **after** `install_tasks` — the class-level setter delegates to the instance that `install_tasks` creates, so assigning it earlier raises `NoMethodError: undefined method 'tag_prefix=' for nil`. (The `rake -T` description still renders the unprefixed tag; the runtime tag is computed lazily and honours the prefix.) A single-package repo can keep plain `vX.Y.Z` and drop the prefix.
3. Workflow (copy `spreen-wiki/.github/workflows/rubygem--release.yml`): triggers on the release-tag pattern (`ruby-v*`), `permissions: contents: write` + `id-token: write`, `ruby/setup-ruby` with `bundler-cache`, then `rubygems/release-gem@v1` — pass `working-directory` when the gem is not at the repo root. The action fetches existing tags first, so the tag that triggered the run is not re-created.
4. **Ordering**: register the publisher and push tags for already-published versions *before* merging the workflow — a tag pushed after the workflow exists fires it, and re-publishing an existing version fails.

#### 2-1-5. Per release

1. Bump `lib/<foo_bar>/version.rb`, move the `Unreleased` `CHANGELOG.md` entries under the new version, merge to `master`.
2. `git tag ruby-vX.Y.Z && git push origin ruby-vX.Y.Z` — the workflow builds and publishes.
3. Cut a GitHub Release for the tag, titled `[RubyGem] vX.Y.Z`: a one-line install lead (`gem install <name>`), then numbered Keep-a-Changelog sections (`## 1. Added`, `2. Changed`, `3. Deprecated`, `4. Removed` — omit empty ones, derive bullets from `CHANGELOG.md`), and a final numbered `Full Changelog` section linking the tag's commits/compare.

API quirk: PATCHing a *draft* release without `tag_name` silently resets its tag to `untagged-…` — always include `tag_name` in the payload.

### 2-2. PyPI

Worked example: the `spreen-wiki` library (sources in `spreen-wiki/PyPI/`, package `spreen_wiki`, CLI `spreen`), published as [`spreen-wiki`](https://pypi.org/project/spreen-wiki/) — v0.1.0 uploaded manually on 2026-07-13, later releases automated. Copy its files as the canonical templates when publishing another library.

Trigger phrases (non-exhaustive — match the intent, not the exact words; the same explicit-authorization rule as § 2-1 applies):

- "Release the PyPI library vX.Y.Z" / "Publish `<name>` vX.Y.Z to PyPI" — run § 2-2-5 end-to-end: version bump + CHANGELOG re-sectioning on a topic branch and PR (§ 1-2); after that PR merges, push the `python-vX.Y.Z` tag (publishes via CI) and cut the GitHub Release.
- "Release vX.Y.Z for both RubyGems and PyPI" — run § 2-1-5 and § 2-2-5 together.
- "Prepare the PyPI release" — § 2-2-5 step 1 only (bump + CHANGELOG + PR); do not tag.
- "Tag python-vX.Y.Z and cut the GitHub Release" — § 2-2-5 steps 2–3 only (for a version already on `master`).
- "Fill in the release description" — write or update a GitHub Release body in the § 2-1-5 format (works on drafts too).
- "Publish `<name>` as a PyPI library" (a new library) — the full pipeline §§ 2-2-2 → 2-2-4.
- "Set up Trusted Publishers for `<name>`" — § 2-2-4 only.

#### 2-2-1. One-time setup (per account)

- Accounts at `https://pypi.org` and `https://test.pypi.org` with 2FA; `pip install build twine` for manual publishing.

#### 2-2-2. Packaging a new library

- Verify the name is unclaimed on pypi.org before committing to it (PyPI normalises `_`/`-`, so `foo-bar` and `foo_bar` collide).
- `src/` layout: package `src/<foo_bar>/`, snake_case package name even when the PyPI project name is dashed.
- `pyproject.toml` essentials: `[build-system]` (setuptools), `version`, `requires-python`, `license` + `license-files`, `classifiers`, `[project.urls]`, `[project.scripts]` for CLIs, `[tool.setuptools.package-data]` for shipped data files (loaded via `importlib.resources`), `py.typed` for typed packages.
- Ship `README.md`, `LICENSE.txt`, and the shared `CHANGELOG.md`.

#### 2-2-3. First publish (manual)

- `python -m build` → `twine check dist/*` → rehearse on TestPyPI (`twine upload -r testpypi` + smoke install) → `twine upload dist/*`.

#### 2-2-4. Automate releases with Trusted Publishers (OIDC, no API keys)

1. Register the publisher at `https://pypi.org/manage/project/<name>/settings/publishing/`: GitHub, repository owner/name, workflow name `pypi--release.yml`, environment name `pypi`.
2. Create the matching GitHub deployment environment (`PUT /repos/<owner>/<repo>/environments/pypi`); the two names must stay in sync or the OIDC exchange is rejected.
3. Workflow (copy `spreen-wiki/.github/workflows/pypi--release.yml`): triggers on the release-tag pattern (`python-v*`); a `build` job makes sdist/wheel (`python -m build`, `working-directory` when not at the repo root) and uploads `dist/` as an artifact; a separate `publish` job bound to `environment: pypi` holds the only `id-token: write` grant, downloads the artifact, and runs `pypa/gh-action-pypi-publish@release/v1`.
4. **Ordering**: same as § 2-1-4 — publisher registration and tags for already-published versions come before the workflow lands.

#### 2-2-5. Per release

1. Bump `version` in `pyproject.toml`, move the `Unreleased` `CHANGELOG.md` entries under the new version, merge to `master`.
2. `git tag python-vX.Y.Z && git push origin python-vX.Y.Z` — the workflow builds and publishes.
3. Cut a GitHub Release titled `[PyPI] vX.Y.Z`, same format as § 2-1-5 with the install lead `pip install <name>` (or `pipx`).

### 2-3. Ruby on Rails Apps

The chosen $0 production target for the Ruby on Rails apps (decided 2026-07-12) is an **Oracle Cloud "Always Free" ARM VM (VM.Standard.A1.Flex, up to 4 OCPUs / 24 GB RAM) deployed with Kamal** — "The Rails Way" — not a PaaS. Rationale: Heroku/Railway/Fly.io no longer have free tiers, Render's free tier cold-starts and its free Postgres expires, while Oracle's Always Free VMs are always-on and pair naturally with Kamal.

- When asked about deploying, provisioning, or CI/CD for production of the Rails apps, assume the target is the Oracle Cloud Always Free VM driven by Kamal (Docker-based).
- The runbook lives at `KAMAL_DEPLOYMENT.md` in this workspace root; each Rails app root has `config/deploy.yml`, `Dockerfile.production`, `bin/docker-entrypoint`, and `.kamal/secrets` (env-references only — safe to commit).
- All four apps share one VM: kamal-proxy routes by hostname; MySQL runs as a per-app Kamal accessory on the internal Docker network.
- Kamal runs from WSL (Ubuntu, rbenv-style login shell), cross-building `arm64` images and pushing them to `ghcr.io/hayat01sh1da/<app>`.

### 2-4. Publishing and installing a package with GitHub Actions

The third distribution channel after §§ 2-1/2-2: a public GitHub Action that installs the published package inside a consumer's workflow and runs it on a schedule — the adoption path for CI-cron tools. Worked example: [`github-wiki-organiser-action`](https://github.com/hayat01sh1da/github-wiki-organiser-action), listed on the Marketplace as **GitHub Wiki Organiser** (v0.1.0, 2026-07-15) — a composite action that checks out the caller's `<repo>.wiki`, runs the organiser (pip-backed, `spreen-wiki` pinned), and commits/pushes when there is a diff. Copy its files as the canonical templates. Note the naming split: functional repo/display names for search (`uses:` lines and the Marketplace), brand kept in the `branding:` icon and the underlying packages.

Trigger phrases (non-exhaustive — match the intent, not the exact words):

- "Publish `<name>` as a GitHub Action" / "Create the GitHub Action for `<package>`" — the full pipeline §§ 2-4-1 → 2-4-3.
- "Release the action vX.Y.Z" — § 2-4-3 steps 2–4 (tag, Release, floating major tag).
- "Add the `<name>` action to `<repo>`'s workflows" — § 2-4-4 in the consuming repository.

#### 2-4-1. Repository layout (Marketplace requirements)

- One action per repository, `action.yml` at the repository root, repository public — Marketplace accepts nothing else.
- `action.yml` must carry `name` (unique across the Marketplace), `description` (**< 125 characters** — the Marketplace rejects longer ones at publish time), and `branding` (`icon` + `color`) to be listable.
- Ship `README.md` (with a copy-pasteable `uses:` example), `LICENSE.txt`, and `CHANGELOG.md` (same Keep-a-Changelog, numbered-heading format as everywhere else).

#### 2-4-2. Designing the action

- Prefer a **composite** action that installs the already-published package instead of duplicating its code: `actions/setup-python` → `pip install <package>` (or `ruby/setup-ruby` → `gem install <name>`) → run the CLI. The package stays the single source of behaviour; the action is a thin adapter, so publish the package first (§§ 2-1/2-2).
- When both ecosystems host the package, back the action with **PyPI** — a runtime-economics choice, not a registry ranking: runners' preinstalled Python already satisfies a `>= 3.10` floor (a gem needing Ruby >= 3.4 pays a `ruby/setup-ruby` toolchain install on every consumer run), preinstalled `pipx` isolates the CLI from the consumer's own Python packages, and the action's startup tax is multiplied across every scheduled run of every consumer. Pick one backend only — supporting both doubles the input surface for zero user-visible benefit.
- Pin the package version in the action (`pip install <package>==X.Y.Z`) and bump it per action release — an unpinned install makes old action tags silently change behaviour.
- Declare `inputs:` for every CLI flag consumers may set (for the wiki organiser: `command`, `group-by`, `language`, `home-overflow`, `wiki-repository`, `template-dir`, `token`, `slack-webhook-url`), with defaults matching the CLI's; mark secrets-carrying inputs clearly and never `echo` them.
- Side effects (committing and pushing results, Slack notifications) should be opt-in via inputs, and the README must state which permissions/secrets the caller needs (`contents: write`, a token that can push to the wiki, webhook URLs).
- Helper composite actions that merely wrap dominant incumbents (`stefanzweifel/git-auto-commit-action`, `slackapi/slack-github-action`, `ruby/setup-ruby`, `actions/setup-python`) stay internal under `.github/actions/` — do not publish those.

#### 2-4-3. Publishing to the Marketplace

1. Validate the action end-to-end from a real consuming workflow before listing it. Two-stage pattern from the worked example: an `Action - CI` workflow in the action repository itself dry-runs the action (`push: false`, `uses: ./`) against a real wiki on every `action.yml` change — covering checkout → install → run; the real *push* validation must run from a workflow inside the target repository, because `GITHUB_TOKEN` can only push to the calling repository's own wiki (cross-repo pushes need a PAT).
2. Tag `vX.Y.Z` (plain SemVer — the action lives in its own repository, so no ecosystem prefix) and cut a GitHub Release titled `vX.Y.Z` in the § 2-1-5 note format.
3. On the Release form, tick **"Publish this Action to the GitHub Marketplace"** (first time requires accepting the Marketplace agreement; the checkbox only appears when `action.yml` satisfies § 2-4-1).
4. Maintain a floating major tag so consumers can pin `@v1` and still receive fixes: `git tag -f v1 vX.Y.Z && git push -f origin v1`. Cut `v1.0.0` only after validation on a real wiki; breaking input changes bump the major (`v2`).

#### 2-4-4. Installing (consuming) the action

- In the consuming repository's workflow: `uses: hayat01sh1da/<action-repo>@v1` with the `with:` inputs; grant only the permissions the README demands.
- Version pinning policy: `@v1` (floating major) for own repositories; exact `@vX.Y.Z` or a full commit SHA where supply-chain rigour matters.
- Scheduled consumers follow § 3's cron conventions (document times in JST).

## 3. Conventions

- **Always use the WSL (Ubuntu) terminal for all work** — run every shell command (git, package managers, builds, releases, file operations) inside WSL, never PowerShell/cmd on the Windows side.
- Never commit, push, or open PRs unless explicitly asked; when asked, follow § 1-2.
- Published packages follow the **`spreen-<function>` branded-house naming** (decided 2026-07-17): gem and PyPI names are identical per tool (`spreen-wiki`, `spreen-pr`, `spreen-tracks`, `spreen-clean`), CLI commands stay functional (`spreen`, `pr-title`, `track-delimiter`, `file-clean`), and Marketplace action repos stay function-first with the `-action` suffix (§ 2-4). New tools take the next `spreen-<function>` suffix rather than a fresh naming discussion; opt out only for reputational isolation of a genuinely risky tool or where no README story surface exists. The repositories were renamed to match on 2026-07-17 — `pr-title-printers` → `spreen-pr`, `itunes-file-delimiter-replacers` → `spreen-tracks`, `file-cleaners` → `spreen-clean` (GitHub redirects the old URLs; local clone remotes updated). All local directories were renamed to match (`spreen-tracks`/`spreen-clean` on 2026-07-17, `pr-title-printers` → `spreen-pr` confirmed done by 2026-07-17).
- Long-running work is tracked on a GitHub issue that serves as the living record — the worked example is [`spreen-wiki#106`](https://github.com/hayat01sh1da/spreen-wiki/issues/106) (the packaging/publishing plan). When asked to reflect progress or a conversation onto the issue (trigger phrases: "Update the issue according to the current progress", "Write this discussion down on the issue", "Reflect `<X>` on the issue"), edit the issue **body** via the REST API rather than adding comments:
  - Check off completed checklist items in place, appending **`Done (YYYY-MM-DD)`** markers with links to the evidence (PRs, releases, workflow runs, registry pages).
  - Keep a status callout (`> [!NOTE]`) near the top summarising what is live and what remains; update it when a phase completes.
  - Record decisions discussed in conversation as their own numbered sections or sub-bullets (e.g. naming rationale, publishing policy), including the *why*, dated. When a decision is later revised, annotate the revision in place instead of deleting the original record.
  - Corrections to previously documented procedures (e.g. a snippet that turned out wrong) are fixed in place with a dated correction note.
  - Runbook-grade knowledge that outgrows the issue (procedures, trigger phrases, lessons like API quirks or size limits) is promoted into this Workspace Guide; the issue keeps the project-specific history.
- Never commit diffs until the user has committed them himself. Task requests like "fix it" authorize editing working trees (and API-side changes) only — leave all changes as uncommitted working-tree edits and report what is ready. Only run the branch/commit/push/PR flow when the message unambiguously asks for it (e.g. "commit and push", "open PRs").
- Commits must be RSA-signed — the Protect Default Branch rule rejects unsigned commits. The signing step is interactive and user-side: when `git commit` prompts for (or blocks on) the signature, refer to `RSA_PASSWORD` on `~/.bash_profile`. Never bypass signing (`--no-gpg-sign`, `commit.gpgsign=false`).
- The `gh` CLI is not installed. Use the GitHub REST API instead, with the token from Git Credential Manager (`printf 'protocol=https\nhost=github.com\n\n' | git credential fill`); never print the token. Repo-level GitHub settings (e.g. Actions permissions) can be changed the same way.
- Repositories hosting packages for both ecosystems keep the sources in **camel-case ecosystem directories `RubyGem/` and `PyPI/`** (decided 2026-07-17 on spreen-pr#101, matching spreen-wiki's layout; spreen-pr briefly used `ruby/`→`rubygem/`/`python/`→`pypi/` before aligning). Windows gotcha: `core.ignorecase=true` hides case-only renames — a directory renamed in Explorer stays lowercase in the index (and on the case-sensitive CI runners) until re-recorded with `git rm -r --cached <old> && git add <New>`; verify with `git ls-files`, and remember `.github/actions/*` composite actions carry `working-directory` values that must be updated with the workflows.
- GitHub Actions workflow files follow `{ecosystem}--ci.yml`,
  `{ecosystem}--daily-dependencies-update.yml`, and `{ecosystem}--release.yml` naming (lowercase prefixes `rubygem--` / `pypi--`); workflow names follow
  `{Ecosystem} - CI`, `{Ecosystem} - Daily Dependencies Update`, and `{Ecosystem} - Release` (`RubyGem - *` / `PyPI - *`).
- Scheduled workflows document cron times in JST (e.g. `0 15 * * *` = 0:00 JST).
- README Actions Status badges use the legacy name-based URL format
  (`https://github.com/hayat01sh1da/<repo>/workflows/<Workflow%20Name>/badge.svg`); keep them in sync with workflow name changes.

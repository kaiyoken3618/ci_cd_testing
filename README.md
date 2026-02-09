# CI/CD Testing Sample (Spring Boot + Jenkins + SonarQube)

This is a simple Spring Boot application used for CI/CD testing with Jenkins and SonarQube.

## Jenkins build failure: `couldn't find remote ref refs/heads/main`

If your Jenkins job fails with:

```text
fatal: couldn't find remote ref refs/heads/main
```

the Jenkins job is trying to fetch a branch named `main`, but your repository likely uses a different default branch (often `master`).

### Why this happens

Your stack trace shows Jenkins is fetching:

```text
git fetch ... +refs/heads/main:refs/remotes/origin/main
```

That fetch fails when the remote has no `main` branch.

### Fix options

1. **Update the Jenkins job branch specifier**
   - In Jenkins job configuration (Pipeline from SCM or Multibranch settings), change branch from `main` to your actual branch (for example `master`).

2. **Or create/rename branch in Git provider**
   - If you want to use `main`, create it in GitHub/GitLab/Bitbucket and push it.

3. **Keep Jenkinsfile and job config consistent**
   - This repository Jenkinsfile checks out `master`:
     ```groovy
     git branch: 'master', url: 'https://github.com/kaiyoken3618/ci_cd_testing.git'
     ```
   - Ensure the Jenkins job is not overriding that to `main`.

### Quick verification commands

Run these in your local clone to confirm what branches exist remotely:

```bash
git remote -v
git ls-remote --heads origin
```

If `refs/heads/main` is missing but `refs/heads/master` exists, set Jenkins to `master`.

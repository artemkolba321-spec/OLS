<h1 align="center">OLS (Open Linux Shell)</h1>

![OLS Banner](assets/banner.svg)<br>
OLS is a DevOps-focused CLI toolkit that turns common multi-step workflows into single predictable commands with logging.
> OLS is an early-stage MVP.
> Expect breaking changes. We're exploring ideas and looking for contributors.

## Why OLS

- reduces repetitive DevOps workflows into single commands
- standardizes logging across tools
- makes CLI workflows reproducible and predictable

## Demo
no OLS
```bash
kubectl apply -f . -R
mkdir -p .github/workflows
nano .github/workflows/ci.yml
cp server.js server.js.bak
```
OLS style
```bash
kuber deploy
cicd init
bak server.js 
```

## installation
### Standard install
```bash
curl -sSL https://raw.githubusercontent.com/Tipix-dev/OLS/main/install.sh | bash
```
### Automatic install
```bash
curl -sSL https://raw.githubusercontent.com/Tipix-dev/OLS/main/install.sh | bash -s -- -y
```
### Preview installation
```bash
curl -sSL https://raw.githubusercontent.com/Tipix-dev/OLS/main/install.sh | bash -s -- --dry-run
```

everything is ready

## philosophy
1. **Everything must be logged**  
   - All actions are recorded, making it easy to spot errors (EE) and trace what happened.

2. **OLS is a friendly set of programs**  
   - Minimal unnecessary flags  
   - Clear and consistent helpers (`--help` and `hp`)  
   - Commands work intuitively, even for advanced workflows.

3. **Designed for pipelines**  
   - All tools are pipeline-friendly, allowing chaining of commands effortlessly.  
   - Supports standard Linux streams (stdin/stdout/stderr) for maximum flexibility.

4. **All packages are downloaded from the Internet.**
   - Packages are downloaded once and can be used offline afterwards.
   - predictability
   - the user learns once

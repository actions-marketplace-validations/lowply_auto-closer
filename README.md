# Auto Closer

This action closes all issues that have a specific label while keeping the latest one(s) open. Works best for daily, weekly or monthly auto created issues (e.g. [lowply/issue-from-template](https://github.com/lowply/issue-from-template/)). Use with care for the initial run especially when you have a large number of open issues with the label.

## Inputs

- `label` (_required_): The label that the target issues should have.
- `keep` (_optional_): The number of issues to keep open. Default: `1`

## Workflow example

```yaml
name: weekly report
on:
  schedule:
  - cron: "0 0 * * 2"
jobs:
  open:
    name: Open new report issue
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    - uses: lowply/issue-from-template@main
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        IFT_TEMPLATE_NAME: template.md
  close:
    needs: open
    name: Close old issues
    runs-on: ubuntu-latest
    steps:
    - uses: lowply/auto-closer@main
      with:
        label: report
        keep: 3
      env:
        GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

## Get set up with SFDX and CumulusCI

(Last Updated: Aug. 2020)

To set up CumulusCI and learn to use the tool, we recommend completing our trail: [Build Applications with CumulusCI](https://trailhead.salesforce.com/en/content/learn/trails/build-applications-with-cumulusci).

### Create a scratch org and make changes

Once you've set up CumulusCI and your Dev Hub, you're ready to start working on Outbound Funds Module.

**Create a Scratch Org:** Create an org built for development. To create a scratch org, called `dev`, with the repository contents loaded in, run:

```bash
cci flow run dev_org --org dev
```

`dev` is one of several suggested scratch org names suggested as common convention when using CumulusCI.

**View Org in CLI:** To see a list of your scratch orgs, run:

```bash
cci org list
```

Note that the output of this command will also show you any "unused" orgs that conform to the suggested cci convention.

**View Org in Browser:** to open your Outbound Funds scratch dev org, run:

```bash
cci org browser dev
```

If you get a new browser tab that's logged into your new scratch org and _Outbound Funds_ shows up in the App Launcher menu, congratulations!

**Checkout a new branch:** If you want to make changes to the Outbound Funds package, the first thing you'll need to do is create a new branch on which to store your changes. Follow the steps [here](https://help.github.com/en/desktop/contributing-to-projects/creating-a-branch-for-your-work) for how to create a new branch using GitHub Desktop.

**Sync Changes:** Salesforce Developers will be familiar with using an editor (such as VS Code) to create and deploy new files to a scratch org - make sure to set your dev scratch org as the default org for the project folder (if you followed the instructions above, it will likely be called `Outbound Funds - Dev Org`).

If you are making declarative changes in the scratch org which you'd like to sync to your local project folder in order to commit to the online repository, first get a list of changes made in the org by running:

```bash
cci task run list_changes --org dev
```

You can refine the set of listed changes by using the `-o exclude` and `-o include` tags to filter as needed. For example, this command would not list any profiles that were changed:

```bash
cci task run list_changes --org dev -o exclude "Profile:"
```

Once you have filtered a list of changes to conform with the changes you want to submit, change the `list_changes` keyword to `retrieve_changes`, like so:

```bash
cci task run retrieve_changes --org dev -o exclude "Profile:"
```

**Commit and Push Changes:** With the list of pulled changes in your local system, you can create a commit and publish your changes to the online repository. See [these instructions](https://help.github.com/en/desktop/contributing-to-projects/committing-and-reviewing-changes-to-your-project#2-selecting-changes-to-include-in-a-commit) for how to do this using Github Desktop.

With your branch pushed to the shared repository, you're ready to create a pull request. Follow these instructions on [how to open a PR](https://help.github.com/en/articles/creating-a-pull-request).

### Code checks

Outbound Funds Module uses GitHub Actions and pre-commit checks to ensure that code and metadata meet specific formatting standards. Specifically, we run checks to ensure that localizable strings are not hard-coded, and that formatting standards used by Prettier are applied to Apex, JavaScript, HTML, YAML, and JSON files.

You can set up these checks to run as pre-commit actions in Git locally, to ensure that pull requests you open are ready for evaluation. To do so, you'll need to set up your system with NPM, Yarn, and Python 3. Then, in a terminal, run

```bash
. scripts/install-pre-commit.sh
```

Note that this setup is for a Mac OS or Linux computer, or a Windows environment that uses a Bash shell. If you use PowerShell on Windows, we recommend using Prettier within Visual Studio Code.

The precommit checks will prevent you from committing code that doesn't meet standards, and will automatically apply Prettier formatting to files you commit. However, if you don't feel comfortable doing this setup or would like to have Prettier inside your Visual Studio Code, you can use the [Visual Studio Code Prettier extension](https://developer.salesforce.com/tools/vscode/en/user-guide/prettier/).

GitHub Actions checks ensure that code is evaluated before it can be merged.

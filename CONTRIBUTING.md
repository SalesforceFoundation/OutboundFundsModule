## Get set up with SFDX and CumulusCI

(Last Updated: Oct. 2019)

Linked below is a document to help you set up your local environment for contributions to Outbound Funds. This document is used as a general primer for CCI installation and training, but conveniently uses the Outbound Funds repository as an example! Follow the steps as needed in order to:

1. Ensure all the right software is installed (sfdx, git, cci)
2. Link your github account and get set up with GitHub desktop
3. Clone the Outbound Funds repo

Follow the instructions [here](https://quip.com/icDYAihiqdB2) through step 7.1 in order to complete the majority of setup. Then come right back here!

### Create a scratch org and make changes

**Create a Scratch Org:** Instead of creating a qa org via CumulusCI, as indicated in step 7.2 of that doc, we'll instead create an org build for active dev. To create a scratch org, called `dev`, with the repository contents loaded in, run:

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

**Checkout a new branch:** If you want to make changes to the Outbound Funds package, the first thing you'll need to do is create a new branch on which to store your changes. Follow the steps [here](https://help.github.com/en/desktop/contributing-to-projects/creating-a-branch-for-your-work) for how to create a new branch using github desktop.

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

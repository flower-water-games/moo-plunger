Contributing Guidelines
=======================

Branching and Pull Request Strategy
-----------------------------------

1. Clone the repository to your local machine using either the command line or GitHub Desktop.

2. Create a new branch for your feature development. Use a descriptive name that reflects the purpose of your changes.

3. Make your changes to the codebase on the newly created branch.

4. Test your changes thoroughly to ensure they work as expected.

5. Commit your changes to your branch name with a clear and concise commit message.

6. Push your branch to the remote repository.

7. Open a pull request (PR) on GitHub to merge your changes into the `main` branch.

8. Provide a detailed description of your changes in the PR.

9. Request a code review from a team member.

10. Address any feedback or comments received during the code review process.

11. Once the PR is approved, the changes will be merged into the `main` branch.

12. Delete the feature branch after it has been merged.

Command Line Instructions
-------------------------

To clone the repository:

```bash
# Clone the repository
git clone https://github.com/flower-water-games/moo-plunger.git

# Navigate into the directory of the cloned repository
cd moo-plunger

# Create a new branch
git checkout -b feature_branch_name

# Make changes to the code

# Stage the changes
git add .

# Commit the changes
git commit -m "Your detailed commit message"

# Push the changes to the remote repository
git push origin feature_branch

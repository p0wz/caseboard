#!/usr/bin/env bash
set -e

echo "=========================================="
echo "  Caseboard: GitHub Pages Deployer        "
echo "=========================================="

REPO_NAME="${1:-caseboard}"
GITHUB_USER="p0wz"
REMOTE_URL="git@github.com:${GITHUB_USER}/${REPO_NAME}.git"

echo "Deploying GitHub Pages documentation from /docs folder..."
echo "Target: https://${GITHUB_USER}.github.io/${REPO_NAME}/"
echo ""

if ! git remote | grep -q "^origin$"; then
    echo ">> Adding git remote origin: ${REMOTE_URL}"
    git remote add origin "${REMOTE_URL}" || true
fi

echo ">> Adding files and committing..."
git add docs/ metadata/ Sources/ Caseboard.xcodeproj/ sync_to_appstoreconnect.sh deploy_github_pages.sh
git commit -m "feat(pages): add official website, privacy policy, and support center for GitHub Pages" || echo "Nothing new to commit."

echo ">> Ready to push to GitHub:"
echo "Run:"
echo "  git push -u origin main"
echo ""
echo "To enable GitHub Pages:"
echo "1. Visit https://github.com/${GITHUB_USER}/${REPO_NAME}/settings/pages"
echo "2. Under 'Build and deployment' -> 'Branch':"
echo "   Select 'main' and folder '/docs'"
echo "3. Click 'Save'. Your site will be live at:"
echo "   https://${GITHUB_USER}.github.io/${REPO_NAME}/"
echo "   https://${GITHUB_USER}.github.io/${REPO_NAME}/privacy.html"
echo "   https://${GITHUB_USER}.github.io/${REPO_NAME}/support.html"
echo "=========================================="

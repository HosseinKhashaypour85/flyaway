#!/bin/bash

echo "🚀 Starting Flutter APK Build..."
echo "Repository: HosseinKhashaypour85/flyaway"
echo ""

# Trigger GitHub Actions workflow
echo "🔄 Triggering GitHub Actions workflow..."
gh workflow run build-apk.yml -f build_type=release

echo ""
echo "✅ Build started! Check GitHub Actions for progress:"
echo "https://github.com/HosseinKhashaypour85/flyaway/actions"
echo ""
echo "📱 Download APK after build completes:"
echo "https://github.com/HosseinKhashaypour85/flyaway/releases/latest/download/app-release.apk"
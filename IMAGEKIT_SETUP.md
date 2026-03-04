# ImageKit.io Setup Guide

## Overview
Your Flutter app has been successfully migrated from Supabase to ImageKit.io for image storage. All image uploads will now use ImageKit's REST API.

## Step 1: Get Your ImageKit Credentials

1. Go to [https://imagekit.io](https://imagekit.io)
2. Sign up or log in to your account
3. Navigate to **Dashboard > Settings > API Keys**
4. Copy your:
   - **Private Key** (keep this secret, never share it)
   - **Public Key** (you may not need this for uploads)
   - **URL Endpoint** (looks like: `https://ik.imagekit.io/youraccountid/`)

## Step 2: Update Your .env File

Add the following lines to your `.env` file:

```env
IMAGEKIT_PRIVATE_KEY=your_private_key_here
IMAGEKIT_PUBLIC_KEY=your_public_key_here
```

Replace `your_private_key_here` and `your_public_key_here` with your actual credentials from ImageKit.

## Where Changes Were Made

### Files Modified:
1. **pubspec.yaml** - Removed `supabase_flutter` dependency
2. **lib/main.dart** - Removed Supabase initialization code
3. **lib/features/teams/screens/create_team_screen.dart** - Updated to use ImageKitServices
4. **lib/features/teams/screens/team_edit_screen.dart** - Updated to use ImageKitServices

### New Files Created:
- **lib/utils/cloud_storage/imagekit_services.dart** - ImageKit integration class

## ImageKitServices API

The `ImageKitServices` class provides two main methods:

### uploadImage()
Uploads an image to ImageKit.io

```dart
final logoUrl = await ImageKitServices.uploadImage(
  imageByte: imageBytes,          // Uint8List
  fileName: 'team-logo.jpg',      // File name
  isExist: false,                 // Whether to replace (for interface compatibility)
  isProfile: false,               // true for profile pictures, false for team logos
);
```

**Returns:** Public URL of the uploaded image (e.g., `https://ik.imagekit.io/youraccountid/team-logos/team-logo.jpg`), or `null` if upload fails.

### deleteImage()
Deletes an image from ImageKit.io

```dart
final success = await ImageKitServices.deleteImage(fileId: 'imageKitFileId');
```

## File Organization

Images are automatically organized in ImageKit with the following folder structure:
- **Profile Pictures:** `/profile-pictures`
- **Team Logos:** `/team-logos`

## Key Features

✅ **Automatic Organization** - Images are sorted by type into folders
✅ **Image Compression** - Images are already compressed before upload
✅ **Secure** - Private keys are loaded from environment variables
✅ **Error Handling** - All errors are logged and handled gracefully
✅ **Simple Interface** - Same method signature as Supabase for easy migration

## Troubleshooting

### Error: "ImageKit credentials not found"
- Make sure your `.env` file contains both `IMAGEKIT_PRIVATE_KEY` and `IMAGEKIT_PUBLIC_KEY`
- Restart your app after updating the `.env` file

### Error: "statusCode 401"
- Your private key is incorrect or has expired
- Verify the key in the ImageKit dashboard

### Error: "statusCode 422"
- Invalid file or request parameters
- Check the file size and format

## Next Steps

1. Run `flutter pub get` to update dependencies
2. Add the ImageKit credentials to your `.env` file
3. Test the app by uploading a team logo
4. Delete the old `supabase_services.dart` file once everything is working

---

For more information about ImageKit.io, visit: https://docs.imagekit.io/

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tracket/features/players/models/player.dart';
import 'package:tracket/features/players/services/players_services.dart';
import 'package:tracket/utils/cloud_storage/imagekit_services.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/enums.dart';
import 'package:tracket/utils/helpers/helping_function.dart';
import 'package:tracket/utils/validator/validator.dart';

class EditPlayerProfileScreen extends StatefulWidget {
  const EditPlayerProfileScreen({
    super.key,
    required this.player,
  });

  final Player player;

  @override
  State<EditPlayerProfileScreen> createState() =>
      _EditPlayerProfileScreenState();
}

class _EditPlayerProfileScreenState extends State<EditPlayerProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  Uint8List? _imageBytes;
  late CricketRole _cricketRole;
  late Position _battingPosition;
  late Position? _bowlingArm;
  late BowlingStyle _bowlingStyle;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.player.name);
    _cricketRole = widget.player.playerCricketDetails!.cricketRole;
    _battingPosition = widget.player.playerCricketDetails!.battingPosition;
    _bowlingArm = widget.player.playerCricketDetails!.bowlingArm;
    _bowlingStyle = widget.player.playerCricketDetails!.bowlingStyle;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get _showBowlingArm => _bowlingStyle != BowlingStyle.none;

  Future<void> _pickProfileImage() async {
    try {
      final image = await THelperFunction.pickImage(ImageSource.gallery);
      if (image == null) return;
      setState(() => _imageBytes = image);
    } catch (e) {
      if (!mounted) return;
      THelperFunction.showSnackBar('Failed to pick image: $e', context);
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    if (_showBowlingArm && _bowlingArm == null) {
      THelperFunction.showSnackBar('Please select bowling position.', context);
      return;
    }

    setState(() => _isSaving = true);
    try {
      String updatedProfileImageUrl = widget.player.profileImageUrl;

      if (_imageBytes != null) {
        final uploadedImageUrl = await ImageKitServices.uploadImage(
          imageByte: _imageBytes!,
          fileName: '${widget.player.id}_profile.jpg',
          isExist: widget.player.profileImageUrl.isNotEmpty,
          isProfile: true,
        );

        if (uploadedImageUrl == null || uploadedImageUrl.isEmpty) {
          if (mounted) {
            THelperFunction.showSnackBar(
                'Failed to upload profile image.', context);
          }
          return;
        }

        updatedProfileImageUrl = uploadedImageUrl;
      }

      await PlayersServices.updatePlayerProfile(
        playerId: widget.player.id,
        name: _nameController.text.trim(),
        profileImageUrl: updatedProfileImageUrl,
        cricketRole: _cricketRole,
        battingPosition: _battingPosition,
        bowlingArm: _showBowlingArm ? _bowlingArm : null,
        bowlingStyle: _bowlingStyle,
      );

      if (!mounted) return;
      THelperFunction.showSnackBar(
          'Player profile updated successfully!', context);
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      THelperFunction.showSnackBar(
          'Failed to update player profile: $e', context);
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  String _formatBowlingStyle(BowlingStyle style) {
    final name = style.name;
    final formatted = name.replaceAllMapped(
      RegExp(r'([a-z])([A-Z])'),
      (match) => '${match.group(1)} ${match.group(2)}',
    );
    return THelperFunction.makeFirstLetterUpperCase(formatted);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunction.isDarkMode(context);
    final imageProvider = _imageBytes != null
        ? MemoryImage(_imageBytes!)
        : (widget.player.profileImageUrl.isNotEmpty
            ? NetworkImage(widget.player.profileImageUrl)
            : null) as ImageProvider<Object>?;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Player Profile'),
        backgroundColor: primaryColor,
        foregroundColor: onPrimary,
        actions: [
          IconButton(
            onPressed: _isSaving ? null : _saveProfile,
            icon: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: onPrimary),
                  )
                : const Icon(Icons.save_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 52,
                      backgroundColor:
                          isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                      backgroundImage: imageProvider,
                      child: imageProvider == null
                          ? const Icon(Icons.person, size: 50)
                          : null,
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: InkWell(
                        onTap: _isSaving ? null : _pickProfileImage,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt,
                              color: onPrimary, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                enabled: !_isSaving,
                decoration: const InputDecoration(
                  labelText: 'Player Name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) =>
                    TValidator.nameValidator(value, 'Player Name'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<CricketRole>(
                initialValue: _cricketRole,
                decoration: const InputDecoration(
                  labelText: 'Cricket Role',
                  prefixIcon: Icon(Icons.sports_cricket),
                ),
                items: CricketRole.values
                    .map(
                      (role) => DropdownMenuItem(
                        value: role,
                        child: Text(role.description),
                      ),
                    )
                    .toList(),
                onChanged: _isSaving
                    ? null
                    : (role) {
                        if (role == null) return;
                        setState(() => _cricketRole = role);
                      },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Position>(
                initialValue: _battingPosition,
                decoration: const InputDecoration(
                  labelText: 'Batting Position',
                  prefixIcon: Icon(Icons.sports_baseball),
                ),
                items: Position.values
                    .map(
                      (position) => DropdownMenuItem(
                        value: position,
                        child: Text(position == Position.righty
                            ? 'Right Handed'
                            : 'Left Handed'),
                      ),
                    )
                    .toList(),
                onChanged: _isSaving
                    ? null
                    : (position) {
                        if (position == null) return;
                        setState(() => _battingPosition = position);
                      },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<BowlingStyle>(
                initialValue: _bowlingStyle,
                decoration: const InputDecoration(
                  labelText: 'Bowling Style',
                  prefixIcon: Icon(Icons.gps_fixed),
                ),
                items: BowlingStyle.values
                    .map(
                      (style) => DropdownMenuItem(
                        value: style,
                        child: Text(_formatBowlingStyle(style)),
                      ),
                    )
                    .toList(),
                onChanged: _isSaving
                    ? null
                    : (style) {
                        if (style == null) return;
                        setState(() {
                          _bowlingStyle = style;
                          if (style == BowlingStyle.none) {
                            _bowlingArm = null;
                          } else {
                            _bowlingArm ??= Position.righty;
                          }
                        });
                      },
              ),
              if (_showBowlingArm) ...[
                const SizedBox(height: 16),
                DropdownButtonFormField<Position>(
                  initialValue: _bowlingArm,
                  decoration: const InputDecoration(
                    labelText: 'Bowling Position',
                    prefixIcon: Icon(Icons.back_hand_outlined),
                  ),
                  items: Position.values
                      .map(
                        (position) => DropdownMenuItem(
                          value: position,
                          child: Text(position == Position.righty
                              ? 'Right Arm'
                              : 'Left Arm'),
                        ),
                      )
                      .toList(),
                  onChanged: _isSaving
                      ? null
                      : (position) {
                          setState(() => _bowlingArm = position);
                        },
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveProfile,
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

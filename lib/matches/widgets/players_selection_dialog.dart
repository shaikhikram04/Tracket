import 'package:flutter/material.dart';
import 'package:tracket/matches/models/match_player_info.dart';
import 'package:tracket/matches/widgets/player_column.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/custom_widgets/my_text_button.dart';

class PlayersSelectionDialog extends StatefulWidget {
  const PlayersSelectionDialog({
    super.key,
    required this.playerList,
    required this.selectedPlayers,
    required this.noOfPlayerCanBeSelected,
  });

  final List<MatchPlayerInfo> playerList;
  final List<MatchPlayerInfo> selectedPlayers;
  final int noOfPlayerCanBeSelected;

  @override
  State<PlayersSelectionDialog> createState() => _PlayersSelectionDialogState();
}

class _PlayersSelectionDialogState extends State<PlayersSelectionDialog> {
  static const double _padding = 20.0;
  static const double _spacing = 10.0;
  static const double _dialogHeightFactor = 0.5;

  late final List<MatchPlayerInfo> _selectedPlayers;

  @override
  void initState() {
    _selectedPlayers =
        widget.selectedPlayers.map((player) => player.copyWith()).toList();

    super.initState();
  }

  void _handlePlayerSelection(MatchPlayerInfo player, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedPlayers.removeWhere((p) => p.playerId == player.playerId);
      } else if (_selectedPlayers.length < widget.noOfPlayerCanBeSelected) {
        _selectedPlayers.add(player.copyWith());
      } else {
        showSnackBar('Players has reached its max capacity', context);
      }
    });
  }

  void _handleSubmit() {
    // final requiredPlayerLen = widget.noOfPlayerCanBeSelected;
    // final selectedPlayerLen = _selectedPlayers.length;
    // final moreToSelect = requiredPlayerLen - selectedPlayerLen;
    //! make sure that all required players are selected
    // if (selectedPlayerLen != requiredPlayerLen) {
    //   showAlertDialog(
    //     context,
    //     'Incomplete selection',
    //     'This match need $requiredPlayerLen players but you selected $selectedPlayerLen. Please select $moreToSelect more player!',
    //   );

    //   return;
    // }
    Navigator.of(context).pop(_selectedPlayers);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Dialog(
      child: SizedBox(
        height: height * _dialogHeightFactor,
        child: Padding(
          padding: const EdgeInsets.all(_padding),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: _spacing),
              _buildPlayerGrid(),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        getTitleText('Select players', context),
        Text('${_selectedPlayers.length}/${widget.noOfPlayerCanBeSelected}')
      ],
    );
  }

  Widget _buildPlayerGrid() {
    return Expanded(
      child: GridView.builder(
        itemCount: widget.playerList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.8,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        itemBuilder: _buildPlayerItem,
      ),
    );
  }

  Widget _buildPlayerItem(BuildContext context, int index) {
    final player = widget.playerList[index];
    final isSelected = _selectedPlayers
        .any((selectedPlayer) => selectedPlayer.playerId == player.playerId);

    return InkWell(
      onTap: () => _handlePlayerSelection(player, isSelected),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? LightThemeColors.cardColor : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: PlayerColumn(
          profileImageUrl: player.profileImageUrl,
          playerName: player.playerName,
          cricketRole: player.cricketRole,
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      spacing: 10,
      children: [
        MyTextButton(
          text: 'Cancel',
          onPressed: () => Navigator.of(context).pop(null),
        ),
        MyTextButton(
          text: 'Submit',
          onPressed: _handleSubmit,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _selectedPlayers.clear();
    super.dispose();
  }
}

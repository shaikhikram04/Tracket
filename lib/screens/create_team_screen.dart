import 'package:flutter/material.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/widgets/my_dropdown_menu.dart';
import 'package:tracket/widgets/my_text_button.dart';
import 'package:tracket/widgets/my_text_field.dart';

class CreateTeamScreen extends StatefulWidget {
  const CreateTeamScreen({super.key});

  @override
  State<CreateTeamScreen> createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends State<CreateTeamScreen> {
  late GlobalKey<FormState> _formKey;
  late TextEditingController _teamNameController;
  late TextEditingController _teamSNController;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _teamNameController = TextEditingController();
    _teamSNController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Team'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 70,
                    backgroundImage: AssetImage('assets/images/team_logo.png'),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    label: const Text(
                      'Edit team logo',
                      style: TextStyle(color: blackColor),
                    ),
                    icon: const Icon(Icons.edit),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    color: Theme.of(context).cardColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 25),
                      child: Column(
                        children: [
                          MyTextField(
                            textController: _teamNameController,
                            label: 'Team Name',
                          ),
                          const SizedBox(height: 20),
                          MyTextField(
                            textController: _teamSNController,
                            label: 'Team Short Name',
                          ),
                          const SizedBox(height: 15),
                          Container(
                            height: 55,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black45,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    'No Player Selected',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                                const Spacer(),
                                MyTextButton(
                                  text: 'Add Player',
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          MyDropdownMenu(
                            options: const [],
                            label: 'Select Caption',
                            onSelect: (value) {},
                          ),
                          const SizedBox(height: 20),
                          MyDropdownMenu(
                            options: const [],
                            label: 'Select WicketKeeper',
                            onSelect: (value) {},
                          ),
                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerRight,
                            child: MyTextButton(
                              text: 'Create',
                              onPressed: () {},
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:evangelism_admin/core/prospect/domain/entities/prospect.dart';
import 'package:evangelism_admin/core/prospect/presentation/bloc/prospect_mixin.dart';
import 'package:evangelism_admin/core/prospect/presentation/interface/widgets/prospect_widget.dart';
import 'package:evangelism_admin/shared/presentation/theme/extra_colors.dart';
import 'package:evangelism_admin/shared/presentation/widgets/error_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AllProspectsPage extends HookWidget with ProspectMixin {
  final String localeID;
  final String locale;
  AllProspectsPage({super.key, required this.localeID, required this.locale});

  @override
  Widget build(BuildContext context) {
    final allProspects =
        useMemoized(() => listAllProspects(documentID: localeID));
    final searchController = useTextEditingController();
    final searchResults = useState<List<Prospect>?>(null);

    void handleSearch(String query) async {
      if (query.isEmpty) {
        searchResults.value = null;
      } else {
        List<Prospect> allProspects =
            await listAllProspects(documentID: localeID).first;
        List<Prospect> filteredLocales = allProspects
            .where((prospect) =>
                prospect.name.toLowerCase().contains(query.toLowerCase()) ||
                prospect.religiousAffiliation
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                prospect.initialContact
                    .toLowerCase()
                    .contains(query.toLowerCase()))
            .toList();
        searchResults.value = filteredLocales;
      }
    }

    // Optional: Declare a Timer variable to store the debouncer timer
    Timer? searchDebouncer;

    void handleSearchDebounced(String value) async {
      // Create a timer with a specific duration (e.g., 500 milliseconds)
      Timer? timer = Timer(const Duration(milliseconds: 500), () {
        // If the timer finishes and the search text hasn't changed, call handleSearch
        if (value == searchController.text) {
          handleSearch(value);
        }
      });

      // Cancel any previous timers before starting a new one
      searchDebouncer?.cancel();
      searchDebouncer = timer;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Locate Prospect'), actions: [
        IconButton(
          onPressed: () => createPDF(localeID, context, Locale(locale)),
          icon: const Icon(CupertinoIcons.doc_text_fill,
              color: ExtraColors.linkLight),
        )
      ]),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16.0, top: 16, bottom: 16),
              child: SearchBar(
                trailing: [
                  if (searchController.text.isNotEmpty)
                    IconButton(
                      onPressed: () {
                        searchController.clear();
                        searchResults.value = null;
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      icon: const Icon(CupertinoIcons.clear_circled),
                    ),
                ].whereType<Widget>().toList(),
                onChanged: (value) => handleSearchDebounced(value),
                hintText: 'Find Prospects (Name,Affilitation,Initial Contact)',
                textStyle: const MaterialStatePropertyAll(
                    TextStyle(color: ExtraColors.grey)),
                controller: searchController,
                padding: const MaterialStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 15)),
                leading:
                    const Icon(CupertinoIcons.search, color: ExtraColors.grey),
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                )),
              ),
            ),
            Expanded(
              child: searchResults.value != null &&
                      searchController.text.isNotEmpty
                  ? searchResults.value!.isEmpty
                      ? const ErrorViewWidget()
                      : ProspectWidget(prospects: searchResults.value!)
                  : searchController.text.isEmpty || searchResults.value == null
                      ? StreamBuilder(
                          stream: allProspects,
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const ErrorViewWidget();
                            } else if (!snapshot.hasData) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.data!.isEmpty) {
                              return const ErrorViewWidget();
                            } else {
                              var prospects = snapshot.data!;
                              return ProspectWidget(prospects: prospects);
                            }
                          })
                      : const ErrorViewWidget(),
            )
          ],
        ),
      ),
    );
  }
}
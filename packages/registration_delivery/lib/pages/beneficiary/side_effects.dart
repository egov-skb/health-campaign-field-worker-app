import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:digit_components/digit_components.dart';
import 'package:digit_data_model/data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registration_delivery/utils/extensions/extensions.dart';

import '../../blocs/delivery_intervention/deliver_intervention.dart';
import '../../blocs/household_overview/household_overview.dart';
import '../../blocs/side_effects/side_effects.dart';
import '../../models/entities/side_effect.dart';
import '../../models/entities/task.dart';
import '../../router/registration_delivery_router.gm.dart';
import '../../utils/constants.dart';
import '../../utils/i18_key_constants.dart' as i18;
import '../../utils/utils.dart';
import '../../widgets/back_navigation_help_header.dart';
import '../../widgets/localized.dart';
import '../../widgets/component_wrapper/product_variant_bloc_wrapper.dart';

@RoutePage()
class SideEffectsPage extends LocalizedStatefulWidget {
  final bool isEditing;
  final List<TaskModel> tasks;

  const SideEffectsPage({
    super.key,
    super.appLocalizations,
    required this.tasks,
    this.isEditing = false,
  });

  @override
  State<SideEffectsPage> createState() => SideEffectsPageState();
}

class SideEffectsPageState extends LocalizedState<SideEffectsPage> {
  List<bool> symptomsValues = [];
  List<String> symptomsTypes = [];
  bool symptomsSelected = true;
  late final List<KeyValue> symptomTypesOptions;

  @override
  void initState() {
    super.initState();
    symptomTypesOptions = (RegistrationDeliverySingleton().symptomsTypes ?? [])
        .map((e) => KeyValue(e, e))
        .toList();

    symptomsTypes = symptomTypesOptions.map((e) => e.key.toString()).toList();

    for (var _ in symptomTypesOptions) {
      symptomsValues.add(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ProductVariantBlocWrapper(
      child: BlocBuilder<ProductVariantBloc, ProductVariantState>(
        builder: (context, productState) {
          return productState.maybeWhen(
            orElse: () => const Offstage(),
            fetched: (productVariants) {
              return BlocBuilder<HouseholdOverviewBloc, HouseholdOverviewState>(
                builder: (context, state) {
                  return BlocBuilder<DeliverInterventionBloc,
                      DeliverInterventionState>(
                    builder: (context, deliveryState) {
                      return Scaffold(
                        body: state.loading
                            ? const Center(child: CircularProgressIndicator())
                            : ScrollableContent(
                                header: const BackNavigationHelpHeaderWidget(
                                  showHelp: false,
                                ),
                                footer: DigitCard(
                                  margin: const EdgeInsets.fromLTRB(
                                      0, kPadding, 0, 0),
                                  padding: const EdgeInsets.fromLTRB(
                                      kPadding, 0, kPadding, 0),
                                  child: DigitElevatedButton(
                                    onPressed: () async {
                                      if (symptomsValues.any((e) => e)) {
                                        setState(() {
                                          symptomsSelected = true;
                                        });

                                        final shouldSubmit =
                                            await DigitDialog.show<bool>(
                                          context,
                                          options: DigitDialogOptions(
                                            titleText: localizations.translate(
                                              i18.deliverIntervention
                                                  .dialogTitle,
                                            ),
                                            contentText:
                                                localizations.translate(
                                              i18.deliverIntervention
                                                  .dialogContent,
                                            ),
                                            primaryAction: DigitDialogActions(
                                              label: localizations.translate(
                                                i18.common.coreCommonSubmit,
                                              ),
                                              action: (ctx) {
                                                final List<String> symptoms =
                                                    [];

                                                for (int i = 0;
                                                    i < symptomsValues.length;
                                                    i++) {
                                                  if (symptomsValues[i]) {
                                                    symptoms.add(
                                                      symptomsTypes[i],
                                                    );
                                                  }
                                                }

                                                final clientReferenceId =
                                                    IdGen.i.identifier;
                                                context
                                                    .read<SideEffectsBloc>()
                                                    .add(
                                                      SideEffectsSubmitEvent(
                                                        SideEffectModel(
                                                          id: null,
                                                          additionalFields: SideEffectAdditionalFields(
                                                            version: 1,
                                                            fields: [
                                                              AdditionalField("boundaryCode",RegistrationDeliverySingleton().boundary?.code),
                                                            ],
                                                          ),
                                                          taskClientReferenceId:
                                                              widget.tasks.last
                                                                  .clientReferenceId,
                                                          projectId:
                                                              RegistrationDeliverySingleton()
                                                                  .projectId,
                                                          symptoms: symptoms,
                                                          clientReferenceId:
                                                              clientReferenceId,
                                                          tenantId:
                                                              RegistrationDeliverySingleton()
                                                                  .tenantId,
                                                          rowVersion: 1,
                                                          auditDetails:
                                                              AuditDetails(
                                                            createdBy:
                                                                RegistrationDeliverySingleton()
                                                                    .loggedInUserUuid!,
                                                            createdTime: context
                                                                .millisecondsSinceEpoch(),
                                                            lastModifiedBy:
                                                                RegistrationDeliverySingleton()
                                                                    .loggedInUserUuid,
                                                            lastModifiedTime:
                                                                context
                                                                    .millisecondsSinceEpoch(),
                                                          ),
                                                          clientAuditDetails:
                                                              ClientAuditDetails(
                                                            createdBy:
                                                                RegistrationDeliverySingleton()
                                                                    .loggedInUserUuid!,
                                                            createdTime: context
                                                                .millisecondsSinceEpoch(),
                                                            lastModifiedBy:
                                                                RegistrationDeliverySingleton()
                                                                    .loggedInUserUuid,
                                                            lastModifiedTime:
                                                                context
                                                                    .millisecondsSinceEpoch(),
                                                          ),
                                                        ),
                                                        false,
                                                      ),
                                                    );
                                                Navigator.of(
                                                  context,
                                                  rootNavigator: true,
                                                ).pop(true);
                                              },
                                            ),
                                            secondaryAction: DigitDialogActions(
                                              label: localizations.translate(
                                                i18.common.coreCommonCancel,
                                              ),
                                              action: (context) => Navigator.of(
                                                context,
                                                rootNavigator: true,
                                              ).pop(false),
                                            ),
                                          ),
                                        );

                                        if (shouldSubmit ?? false) {
                                          final reloadState = context
                                              .read<HouseholdOverviewBloc>();

                                          Future.delayed(
                                            const Duration(milliseconds: 500),
                                            () {
                                              reloadState.add(
                                                HouseholdOverviewReloadEvent(
                                                  projectId:
                                                      RegistrationDeliverySingleton()
                                                          .projectId!,
                                                  projectBeneficiaryType:
                                                      RegistrationDeliverySingleton()
                                                          .beneficiaryType!,
                                                ),
                                              );
                                            },
                                          ).then((value) => context.router.push(
                                                HouseholdAcknowledgementRoute(
                                                  enableViewHousehold: true,
                                                ),
                                              ));
                                        }
                                      } else {
                                        setState(() {
                                          symptomsSelected = false;
                                        });
                                      }
                                    },
                                    child: Center(
                                      child: Text(
                                        localizations.translate(
                                          i18.common.coreCommonNext,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                slivers: [
                                  SliverToBoxAdapter(
                                    child: DigitCard(
                                      padding: const EdgeInsets.only(
                                        left: kPadding * 2,
                                        right: kPadding * 2,
                                        top: kPadding * 2,
                                        bottom: kPadding * 2,
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  localizations.translate(
                                                    i18.adverseEvents
                                                        .sideEffectsLabel,
                                                  ),
                                                  style: theme
                                                      .textTheme.displayMedium,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                right: kPadding * 2,
                                                top: kPadding * 2,
                                                bottom: kPadding * 2,
                                              ),
                                              child: Text(
                                                '${localizations.translate(
                                                  i18.adverseEvents
                                                      .selectSymptomsLabel,
                                                )}*',
                                                style: theme
                                                    .textTheme.headlineSmall,
                                              ),
                                            ),
                                          ),
                                          StatefulBuilder(
                                            builder: (
                                              BuildContext context,
                                              StateSetter stateSetter,
                                            ) {
                                              return Column(
                                                children: [
                                                  Column(
                                                    children:
                                                        symptomTypesOptions
                                                            .mapIndexed(
                                                              (i, e) =>
                                                                  DigitCheckboxTile(
                                                                padding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                label: localizations
                                                                    .translate(
                                                                  e.key,
                                                                ),
                                                                value:
                                                                    symptomsValues[
                                                                        i],
                                                                onChanged:
                                                                    (value) {
                                                                  stateSetter(
                                                                    () {
                                                                      symptomsValues[
                                                                              i] =
                                                                          !symptomsValues[
                                                                              i];
                                                                      symptomsSelected =
                                                                          symptomsValues
                                                                              .any(
                                                                        (e) =>
                                                                            e,
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                              ),
                                                            )
                                                            .toList(),
                                                  ),
                                                  Visibility(
                                                    visible: !symptomsSelected,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        localizations.translate(
                                                          i18.common
                                                              .coreCommonRequiredItems,
                                                        ),
                                                        style: TextStyle(
                                                          color: theme
                                                              .colorScheme
                                                              .error,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

import 'dart:html';
import 'dart:js';

import 'package:dockcheck_web/features/details/bloc/details_cubit.dart';
import 'package:dockcheck_web/models/employee.dart';
import 'package:dockcheck_web/models/picture.dart';
import 'package:dockcheck_web/utils/colors.dart';
import 'package:dockcheck_web/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/document.dart';
import '../../utils/formatter.dart';
import '../../utils/theme.dart';
import '../../widgets/title_value_widget.dart';

class DetailsView extends StatelessWidget {
  final String employeeId;

  DetailsView({
    super.key,
    required this.employeeId,
  });

  @override
  Widget build(BuildContext context) {
    context.read<DetailsCubit>().getEmployeeAndDocuments(employeeId);
    return BlocBuilder<DetailsCubit, DetailsState>(
      builder: (context, state) {
        if (state is DetailsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is DetailsError) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is DetailsLoaded) {
          final documents = state.documents;
          final employee = state.employee;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  width: double.infinity,
                  color: DockColors.iron100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(employee.name,
                            style: DockTheme.h1.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis),
                      ),
                      Text('|   N° ${employee.number.toString()}',
                          style: DockTheme.h1.copyWith(color: Colors.white),
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                _buildDocumentsCard(documents, employee, context, state.urls),
                // Additional Widgets for displaying user details
              ],
            ),
          );
        } else {
          return const Center(child: Text('Erro desconhecido'));
        }
      },
    );
  }

  Widget _buildDocumentsCard(List<Document> documents, Employee employee,
      BuildContext context, List<String> urls) {
    return Container(
      width: double.infinity,
      color: DockColors.white,
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Texts with titke and value, one above the other, for each employee data
            TitleValueWidget(
              title: "Empresa",
              value: employee.thirdCompanyId,
            ),
            TitleValueWidget(
              title: "Função",
              value: employee.role,
            ),
            TitleValueWidget(
              title: "CPF",
              value: employee.cpf,
            ),
            TitleValueWidget(
              title: "Email",
              value: employee.email,
            ),
            TitleValueWidget(
              title: "Acesso (embarcação, dique seco ou ambas)",
              value: employee.area,
            ),

            const SizedBox(height: 16),
            //card with the documents
            Card(
              color: DockColors.background,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Documentos',
                      style: DockTheme.h2.copyWith(color: DockColors.iron100),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      children: documents
                          .map((document) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        flex: 5,
                                        child: Text(
                                          document.type,
                                          overflow: TextOverflow.ellipsis,
                                          style: DockTheme.h2.copyWith(
                                              color: DockColors.iron100,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 5,
                                        child: Text(
                                          'Validade: ${Formatter.formatDateTime(document.expirationDate)}',
                                          overflow: TextOverflow.ellipsis,
                                          style: DockTheme.h2.copyWith(
                                              color: DockColors.iron100,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 8),
                                  //download container inkwell button with icon
                                  InkWell(
                                    onTap: () {
                                      //convert document.url download to a pdf
                                      final url = document.path;
                                      final anchor = AnchorElement(href: url)
                                        ..setAttribute('download', '');
                                      anchor.click();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: DockColors.iron100,
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.download,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Baixar',
                                            style: DockTheme.h3.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: const Divider(
                                      color: DockColors.iron30,
                                      thickness: 1,
                                    ),
                                  ),
                                ],
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

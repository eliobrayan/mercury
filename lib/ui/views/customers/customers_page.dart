import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mercury/core/providers/crud_provider.dart';
import 'package:mercury/core/providers/customers_provider.dart';
import 'package:mercury/core/providers/enum_states.dart';
import 'package:mercury/misc/colors.dart';
import 'package:mercury/misc/sized.dart';
import 'package:mercury/models/customer_model.dart';
import 'package:mercury/ui/views/customers/form_customers_page.dart';
import 'package:mercury/widgets/shared/dialogs.dart';
import 'package:mercury/widgets/shared/inputs.dart';
import 'package:provider/provider.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({Key key}) : super(key: key);

  @override
  _CustomersPageState createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TabBar(
                tabs: [
                  Tab(
                    icon: Icon(Icons.person),
                  ),
                  Tab(
                    icon: Icon(Icons.list),
                  ),
                ],
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.add),
          foregroundColor: MyColors.primary,
          label: Text(
            "Crear cliente",
            style: TextStyle(color: MyColors.primary),
          ),
          onPressed: () async {
            var result = await Navigator.of(context).push(
              PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) =>
                    FormCustomerPage(),
              ),
            );
            if (result is bool) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                createSnackBar(context, "Cliente creado");
              });
            }
          },
        ),
        body: TabBarView(
          children: [bodyCustomersHome(), bodyListCustomers()],
        ),
      ),
    );
  }

  Widget bodyCustomersHome() {
    return SingleChildScrollView(
      child: Column(
        children: [
          cardInformation(
              backgroundColor: MyColors.warning,
              title: "Hoy",
              subtitle: "Número de clientes",
              info: "25"),
          cardInformation(
              backgroundColor: MyColors.warning,
              title: "Hoy",
              subtitle: "Número de clientes",
              info: "25"),
          cardInformation(
              backgroundColor: MyColors.warning,
              title: "Hoy",
              subtitle: "Número de clientes",
              info: "25"),
          cardInformation(
              backgroundColor: MyColors.warning,
              title: "Hoy",
              subtitle: "Número de clientes",
              info: "25"),
        ],
      ),
    );
  }

  Widget bodyListCustomers() {
    Provider.of<CustomersProvider>(context, listen: false).getCustomers();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Listado de clientes",
                style: TextStyle(
                    color: MyColors.secondary, fontSize: MySizes.title6),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            searchInput(
                hintText: "¿A quién estás buscando?",
                controller: searchController,
                onChanged: (value) {
                  Provider.of<CustomersProvider>(context, listen: false)
                      .searchCustomer(value);
                }),
            SizedBox(
              height: 20,
            ),
            mounted
                ? Consumer<CustomersProvider>(builder: (context, value, _) {
                    print(value.state);
                    print(value.customers);
                    if (value.state == ProviderStates.done) {
                      print("hola");
                      if (value.dirtyCustomers == null) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        if (value.dirtyCustomers.length > 0) {
                          return ListView.separated(
                              separatorBuilder: (BuildContext context,
                                      int index) =>
                                  Divider(
                                    height: 0.5,
                                    indent: 30,
                                    thickness: 2,
                                    color: MyColors.coral,
                                    endIndent:
                                        MediaQuery.of(context).size.width * 0.4,
                                  ),
                              itemCount: value.dirtyCustomers.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (_, index) {
                                return ListTile(
                                  title: Text(value.dirtyCustomers
                                      .elementAt(index)
                                      .name),
                                  subtitle: Text(value.dirtyCustomers
                                          .elementAt(index)
                                          .lastName ??
                                      ""),
                                  tileColor: MyColors.transparent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  trailing: Wrap(
                                    spacing: 1,
                                    children: [
                                      IconButton(
                                          icon: Icon(Icons.edit),
                                          color: MyColors.light,
                                          onPressed: () async {
                                            var result =
                                                await Navigator.of(context)
                                                    .push(
                                              PageRouteBuilder(
                                                opaque: false,
                                                pageBuilder:
                                                    (BuildContext context, _,
                                                            __) =>
                                                        FormCustomerPage(
                                                  customer: value.dirtyCustomers
                                                      .elementAt(index),
                                                ),
                                              ),
                                            );
                                            if (result is bool) {
                                              WidgetsBinding.instance
                                                  .addPostFrameCallback((_) {
                                                createSnackBar(context,
                                                    "Cliente actualizado");
                                              });
                                            }
                                          }),
                                      IconButton(
                                          icon: Icon(Icons.delete),
                                          color: MyColors.error,
                                          onPressed: () async {
                                            print("delete user");
                                            bool response =
                                                await showQuestionDialog(
                                                    context: context,
                                                    title: "Importante",
                                                    content:
                                                        "¿Estás seguro de eliminar a ${value.dirtyCustomers.elementAt(index).name}?",
                                                    textOk: "Si, eliminar");
                                            print("la respuesta es:$response");
                                            if (response) {
                                              Provider.of<CRUDProvider>(context,
                                                      listen: false)
                                                  .deleteEntity(
                                                      "customers",
                                                      value.dirtyCustomers
                                                          .elementAt(index)
                                                          .id);
                                              WidgetsBinding.instance
                                                  .addPostFrameCallback((_) {
                                                createSnackBar(context,
                                                    "Cliente eliminado");
                                              });
                                            }
                                          })
                                    ],
                                  ),
                                  onTap: () async {
                                    print(value.dirtyCustomers
                                        .elementAt(index)
                                        .toString());
                                  },
                                );
                              });
                        } else {
                          return Text("No hay resultados");
                        }
                      }
                    }
                    if (value.state == ProviderStates.error) {
                      return Text("Error");
                    }
                    return Text("Lista de clientes");
                  })
                : Text("hola")
          ],
        ),
      ),
    );
  }

  Widget cardInformation({
    Color backgroundColor,
    String title,
    String subtitle,
    String info,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: backgroundColor,
      ),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  title,
                  style: TextStyle(
                      color: MyColors.primary, fontSize: MySizes.subTitle),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                      color: MyColors.primary, fontSize: MySizes.subtitle2),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                info,
                style: TextStyle(
                    color: MyColors.primary, fontSize: MySizes.title5),
              )
            ],
          )
        ],
      ),
    );
  }
}

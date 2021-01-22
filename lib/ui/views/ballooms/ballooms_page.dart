import 'package:flutter/material.dart';
import 'package:mercury/core/providers/crud_provider.dart';
import 'package:mercury/core/providers/Ballooms_provider.dart';
import 'package:mercury/core/providers/enum_states.dart';
import 'package:mercury/misc/colors.dart';
import 'package:mercury/misc/sized.dart';
import 'package:mercury/ui/views/Ballooms/form_Ballooms_page.dart';
import 'package:mercury/widgets/shared/dialogs.dart';
import 'package:mercury/widgets/shared/inputs.dart';
import 'package:mercury/widgets/shared/widgets.dart';
import 'package:provider/provider.dart';

class BalloomsPage extends StatefulWidget {
  const BalloomsPage({Key key}) : super(key: key);

  @override
  _BalloomsPageState createState() => _BalloomsPageState();
}

class _BalloomsPageState extends State<BalloomsPage> {
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
            "Crear Balón",
            style: TextStyle(color: MyColors.primary),
          ),
          onPressed: () async {
            var result = await Navigator.of(context).push(
              PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) =>
                    FormBalloomsPage(),
              ),
            );
            if (result is bool) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                createSnackBar(context, "Balón creado");
              });
            }
          },
        ),
        body: TabBarView(
          children: [bodyBalloomsHome(), bodyListBallooms()],
        ),
      ),
    );
  }

  Widget bodyBalloomsHome() {
    var size = MediaQuery.of(context).size;
    final double itemHeight = size.height;
    final double itemWidth = size.width * 1.8;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: (itemWidth / itemHeight),
        children: [
          cardInformation(
              backgroundColor: MyColors.coral,
              title: "Hoy",
              subtitle: "Total de clientes",
              info: "25",
              icon: Icon(Icons.person)),
          cardInformation(
              backgroundColor: MyColors.coral,
              title: "Este mes",
              subtitle: "Total de clientes",
              info: "25",
              icon: Icon(Icons.person)),
          cardInformation(
              backgroundColor: MyColors.error,
              title: "Esta semana",
              subtitle: "Total de clientes",
              info: "25",
              icon: Icon(Icons.person)),
          cardInformation(
              backgroundColor: MyColors.errorLight,
              title: "Deudores",
              subtitle: "Deudores",
              info: "25",
              icon: Icon(Icons.person)),
        ],
      ),
    );
  }

  Widget bodyListBallooms() {
    Provider.of<BalloomsProvider>(context, listen: false).getBallooms();
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
                "Listado de balones",
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
                  Provider.of<BalloomsProvider>(context, listen: false)
                      .searchCustomer(value);
                }),
            SizedBox(
              height: 20,
            ),
            mounted
                ? Consumer<BalloomsProvider>(builder: (context, value, _) {
                    print(value.state);
                    print(value.ballooms);
                    if (value.state == ProviderStates.done) {
                      print("hola");
                      if (value.dirtyBallooms == null) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        if (value.dirtyBallooms.length > 0) {
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
                              itemCount: value.dirtyBallooms.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (_, index) {
                                return ListTile(
                                  title: Text(value.dirtyBallooms
                                      .elementAt(index)
                                      .name),
                                  subtitle: Text(value.dirtyBallooms
                                          .elementAt(index)
                                          .type ??
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
                                                        FormBalloomsPage(
                                                  balloom: value.dirtyBallooms
                                                      .elementAt(index),
                                                ),
                                              ),
                                            );
                                            if (result is bool) {
                                              WidgetsBinding.instance
                                                  .addPostFrameCallback((_) {
                                                createSnackBar(context,
                                                    "Balón actualizado");
                                              });
                                            }
                                          }),
                                      IconButton(
                                          icon: Icon(Icons.delete),
                                          color: MyColors.error,
                                          onPressed: () async {
                                            print("delete balloom");
                                            bool response =
                                                await showQuestionDialog(
                                                    context: context,
                                                    title: "Importante",
                                                    content:
                                                        "¿Estás seguro de eliminar a ${value.dirtyBallooms.elementAt(index).name}?",
                                                    textOk: "Si, eliminar");
                                            print("la respuesta es:$response");
                                            if (response) {
                                              Provider.of<CRUDProvider>(context,
                                                      listen: false)
                                                  .deleteEntity(
                                                      "ballooms",
                                                      value.dirtyBallooms
                                                          .elementAt(index)
                                                          .id);
                                              WidgetsBinding.instance
                                                  .addPostFrameCallback((_) {
                                                createSnackBar(context,
                                                    "Balón eliminado");
                                              });
                                            }
                                          })
                                    ],
                                  ),
                                  onTap: () async {
                                    print(value.dirtyBallooms
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
}

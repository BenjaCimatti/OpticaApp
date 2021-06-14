import 'package:flutter/material.dart';
import 'package:optica/classes/ColorPalette.dart';
import 'package:optica/models/Envio.dart';
import 'package:optica/repository/EnvioRepository.dart';
import 'dart:math' as math;

// ignore: must_be_immutable
class ListaEnvios extends StatefulWidget {

  String token;
  String username;
  String baseUrl;

  ListaEnvios({
    required this.token,
    required this.username,
    required this.baseUrl,
  });

  @override
  _ListaEnviosState createState() => _ListaEnviosState();
}

class _ListaEnviosState extends State<ListaEnvios> {

  late Future<List<Envio>> envio;

  @override
  void initState() {
    super.initState();
    envio = EnvioRepository(baseUrl: widget.baseUrl).getEnvio(widget.token, context);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    

    return Scaffold(
      backgroundColor: ColorPalette().getBluishGrey(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 14, top: 0),
              decoration: BoxDecoration(
                color: ColorPalette().getBluishGrey(),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    blurRadius: 10,
                    offset: Offset.fromDirection(math.pi/2, -9)
                  )
                ]
              ),
              child: ListTile(
                title: Text(
                  'Envíos',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: height * 0.08,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(left: 2.1),
                  child: Text(
                    widget.username,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      height: 0.1,
                      fontFamily: 'Poppins',
                      color: Colors.white.withOpacity(0.5),
                      fontWeight: FontWeight.w300,
                      fontSize: height * 0.03,
                    ),
                  ),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.local_shipping_rounded,
                      color: ColorPalette().getLightGreen(),
                      size: height * 0.083,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: FutureBuilder<List<Envio>>(
                future: envio,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Envio> lista;
                    lista = snapshot.data!.toList();

                    return Container(
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: lista.length,
                        itemBuilder: (context, index) {
                          return _createListTile(lista[index]);
                        }
                      ),
                    );

                  }
                  return Center(child: CircularProgressIndicator());
                }
              ),
            ),
          ],
        ),
      ),
    );
  }

  _createListTile(Envio envio) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
      child: Card(
        elevation: 0,
        color: ColorPalette().getLightBlueishGrey(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: ListTile(
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.circle, color: ColorPalette().getLightGreen(),),
            ],
          ),
          isThreeLine: true,
          title: Text(
            envio.descCliente,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              color: ColorPalette().getLightGreen()
            ),
          ),
          subtitle: Text(
            'Id de envío: ${envio.idEnvio}\nFecha de carga: ${envio.fechaCarga}',
            style: TextStyle(
              color: ColorPalette().getLightBlue(),
              fontWeight: FontWeight.w600
            ),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          onTap: () => print('hola'),
        ),
      ),
    );
  }
}
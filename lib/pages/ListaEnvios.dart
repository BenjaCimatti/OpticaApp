import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:optica/classes/ColorPalette.dart';
import 'package:optica/models/Envio.dart';
import 'package:optica/models/Token.dart';
import 'package:optica/repository/EnvioRepository.dart';
import 'package:optica/repository/TokenRepository.dart';
import 'package:optica/widgets/NoData.dart';
import 'dart:math' as math;
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:optica/widgets/TrailingIcon.dart';

// ignore: must_be_immutable
class ListaEnvios extends StatefulWidget {

  String token;
  String? username;
  String? descUsuario;
  String baseUrl;

  ListaEnvios({
    required this.token,
    this.username,
    this.descUsuario,
    required this.baseUrl,
  });

  @override
  _ListaEnviosState createState() => _ListaEnviosState();
}

class _ListaEnviosState extends State<ListaEnvios> {

  late Future<List<Envio>> envio;
  late Future<bool> isExpired;
  late Future<Token> renewedToken;

  final _markedEnvios = <Envio>[];

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    envio = EnvioRepository(baseUrl: widget.baseUrl).getEnvio(widget.token, context);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButton:
        FloatingActionButton(
          onPressed: (){
            setState(() {
              _verifyToken(() {
                _markedEnvios.forEach((element) {
                  print('Cliente: ${element.descCliente}\nId de envio: ${element.idEnvio}');
                });
              });
            });
          },
          backgroundColor: ColorPalette().getLightGreen(),
          elevation: 0,
          child: Icon(Icons.local_shipping_rounded),
        ),

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
                isThreeLine: true,
                title: Text(
                  'Envíos',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: height * 0.07,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(left: 2.1),
                  child: Text(
                    '${widget.descUsuario}\n${widget.username}',
                    style: TextStyle(
                      height: 1.1,
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
                    SvgPicture.asset('assets/svg/Logo.svg')
                  ],
                ),
              ),
            ),
            FutureBuilder<List<Envio>>(
              future: envio,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Envio> lista;
                  lista = snapshot.data!.toList();

                  return Expanded(
                    child: FadingEdgeScrollView.fromScrollView(
                      gradientFractionOnEnd: 0.06,
                      gradientFractionOnStart: 0.06,
                      child: CustomScrollView(
                        controller: _scrollController,
                        physics: BouncingScrollPhysics(),
                        slivers: [
                          CupertinoSliverRefreshControl(onRefresh: _loadEnvios,),
                          SliverToBoxAdapter(
                            child: ListView.builder(
                              padding: const EdgeInsets.only(bottom: kFloatingActionButtonMargin + 48),
                              shrinkWrap: true,
                              primary: false,
                              itemCount: lista.length,
                              itemBuilder: (context, index) {
                                return _createListTile(lista[index]);
                              }
                            ),
                          ),
                        ]
                      ),
                    )
                  );

                } else if (snapshot.hasError) {
                  var error = snapshot.error;

                  if(error!.toString().contains('401')) {
                    // 
                  }
                  
                  
                  return Container();
                } else {
                  return NoData(width: width, height: height);
                }
              }
            ),
          ],
        ),
      ),
    );
  }

  Widget _createListTile(Envio envio) {
    final bool alreadyMarked = _markedEnvios.contains(envio);

    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
      child: Card(
        elevation: 0,
        color: ColorPalette().getLightBlueishGrey(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: ListTile(
          trailing: alreadyMarked ? 
            TrailingIcon(color: ColorPalette().getLightGreen()) : TrailingIcon(color: Colors.black.withOpacity(0),),
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
          onTap: () {
            setState(() {
            if(alreadyMarked) {
              _markedEnvios.remove(envio);
            } else {
              _markedEnvios.add(envio);
            }          
            });
          },
        ),
      ),
    );
  }

  Future<void> _loadEnvios() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _verifyToken(() {
        envio = EnvioRepository(baseUrl: widget.baseUrl).getEnvio(widget.token, context);
      });
    });
  }

  void _verifyToken(void Function() functionality) {
      isExpired = TokenRepository(baseUrl: widget.baseUrl).isTokenExpired(widget.token, context);

      isExpired.then((value) {
        if (value == false) {
          print('token no expirado');
          // funcionalidad
          functionality();
        } else {
          print('token expirado');
          renewedToken = TokenRepository(baseUrl: widget.baseUrl).renewToken(widget.token, context);
          
          renewedToken.then((value) {
            print(widget.token);
            widget.token = value.token;
            print(widget.token);
            functionality();
          });
        }
      });
  }

}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:optica/classes/ColorPalette.dart';
import 'package:optica/classes/Location.dart';
import 'package:optica/models/Envio.dart';
import 'package:optica/models/Token.dart';
import 'package:optica/repository/EnvioConfirmadoRepository.dart';
import 'package:optica/repository/EnvioInformadoRepository.dart';
import 'package:optica/repository/EnvioRepository.dart';
import 'package:optica/repository/TokenRepository.dart';
import 'package:optica/widgets/Dropdown.dart';
import 'package:optica/widgets/MyAlertDialog.dart';
import 'package:optica/widgets/MyConfirmationDialog.dart';
import 'package:optica/widgets/MyInformDialog.dart';
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
  late Future<int> confirmedEnvio;
  late Future<Position> position;
  late Future<int> failedEnvio;

  late bool isButtonDisabled;

  late List<Envio> lista;
  final _markedEnvios = <Envio>[];

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    isButtonDisabled = false;
    envio = EnvioRepository(baseUrl: widget.baseUrl).getEnvio(widget.token, context);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () {
        return new Future(() => false);
      },
      child: Scaffold(
        floatingActionButton:
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                heroTag: 'btnInform',
                onPressed: () {
                  if (_markedEnvios.length > 0) {
                    print('envios mayor a 0');
                    MyConfirmationDialog(
                      context: context,
                      alertTitle: 'Informar inconveniente de un envío',
                      alertContent: alertContent('informará'),
                      buttonText1: 'CANCELAR',
                      buttonText2: 'INFORMAR',
                      buttonAction1: () => Navigator.pop(context),
                      buttonAction2: () {
                        Navigator.pop(context);
                        _dropdownDialog(context);
                      },
                      isButtonDisabled: false
                    ).createDialog();
                  } else {
                    print('no hay envios');
                    MyDialog(
                      context: context,
                      alertTitle: 'Ningún envío seleccionado',
                      alertContent: 'Por favor, seleccione el envio en el que desee informar un inconveniente',
                      buttonText: 'Ok',
                      buttonAction: () => Navigator.pop(context)
                    ).createDialog();
                  }
                },
                backgroundColor: ColorPalette().getPastelRed(),
                elevation: 1,
                child: Icon(Icons.error_outline),
              ),
              SizedBox(
                height: 10,
              ),
              FloatingActionButton(
                heroTag: 'btnConfirm',
                onPressed: (){
                  if (_markedEnvios.length > 0) {
                    print('envios mayor a 0');
                    MyConfirmationDialog(
                      context: context,
                      alertTitle: 'Confirmación de envío',
                      alertContent: alertContent('confirmará'),
                      buttonText1: 'CANCELAR',
                      buttonText2: 'CONFIRMAR',
                      buttonAction1: () => Navigator.pop(context),
                      buttonAction2: () { 
                        _confirmEnvio(context);
                        setState(() {
                          isButtonDisabled = true;          
                        });
                      },
                      isButtonDisabled: isButtonDisabled,
                    ).createDialog();
                  } else {
                    print('no hay envios');
                    MyDialog(
                      context: context,
                      alertTitle: 'Ningún envío seleccionado',
                      alertContent: 'Por favor, seleccione el envio que desee marcar como completado',
                      buttonText: 'Ok',
                      buttonAction: () => Navigator.pop(context)
                    ).createDialog();
                  }
                },
                backgroundColor: ColorPalette().getLightGreen(),
                elevation: 1,
                child: Icon(Icons.local_shipping_rounded),
              ),
            ],
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
                    lista = snapshot.data!.toList();

                    return Expanded(
                      child: FadingEdgeScrollView.fromScrollView(
                        gradientFractionOnEnd: 0.06,
                        gradientFractionOnStart: 0.06,
                        child: CustomScrollView(
                          controller: _scrollController,
                          physics: AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics()
                          ),
                          slivers: [
                            CupertinoSliverRefreshControl(onRefresh: _loadEnvios,),
                            SliverToBoxAdapter(
                              child: ListView.builder(
                                padding: const EdgeInsets.only(bottom: kFloatingActionButtonMargin + 100),
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
                  } else {
                    return NoData(width: width, height: height);
                  }
                }
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmEnvio(BuildContext context) async {
    _verifyToken(() {
      print('Envios marcados restantes: $_markedEnvios');
      position = determinePosition(context);
      position.then((location) {
        var lat = location.latitude;
        var long = location.longitude;
        var length = _markedEnvios.length;

        for (var i = 0; i < length; i++) {
          Envio element = _markedEnvios[0];
          print(element.idEnvio);
          confirmedEnvio = EnvioConfirmadoRepository(baseUrl: widget.baseUrl).confirmEnvio(element.idEnvio, lat, long, widget.token, context);
          _markedEnvios.remove(element);
          print('Envios marcados restantes: $_markedEnvios');
          if (_markedEnvios.length == 0) {
            confirmedEnvio.then((value) {
              envio = EnvioRepository(baseUrl: widget.baseUrl).getEnvio(widget.token, context);
              isButtonDisabled = false;         
              Navigator.pop(context);
              setState(() {});
            });
          }
        }
      });
    });
  }

  Future<void> _informEnvio(DropdownMenu dropdownMenu, BuildContext context) async {
    _verifyToken(() {
      position = determinePosition(context);
      position.then((location) {
        var lat = location.latitude;
        var long = location.longitude;
        var length = _markedEnvios.length;

        for (var i = 0; i < length; i++) {
          Envio element = _markedEnvios[0];
          String observacion = dropdownMenu.getDropdownValue();
          print(element.idEnvio);
          failedEnvio = EnvioInformadoRepository(baseUrl: widget.baseUrl).informEnvio(element.idEnvio, lat, long, observacion, widget.token, context);
          _markedEnvios.remove(element);
          print('Envios marcados restantes: $_markedEnvios');
          if (_markedEnvios.length == 0) {
            failedEnvio.then((value) {
              envio = EnvioRepository(baseUrl: widget.baseUrl).getEnvio(widget.token, context);
              isButtonDisabled = false;
              Navigator.pop(context);
              setState(() {});
            });
          }
        }
      });
    });
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
          trailing: alreadyMarked ? TrailingIcon(color: ColorPalette().getLightGreen()) : TrailingIcon(color: Colors.black.withOpacity(0),),
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
            'Id de envío: ${envio.idEnvio}\nFecha de carga: ${envio.fechaCarga}\nFecha de envío: ${envio.fechaEnvio}',
            style: TextStyle(
              color: ColorPalette().getLightBlue(),
              fontWeight: FontWeight.w600
            ),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          onLongPress: () {
            MyDialog(
              context: context,
              alertTitle: 'Observaciones Envío ${envio.idEnvio}',
              alertContent: '${envio.observaciones}',
              buttonText: 'Ok',
              buttonAction: () => Navigator.pop(context)
            ).createDialog();
          },
          onTap: () {
            setState(() {
            if(alreadyMarked) {
              _markedEnvios.remove(envio);
            } else {
              _markedEnvios.clear();
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
    _verifyToken(() {
      envio = EnvioRepository(baseUrl: widget.baseUrl).getEnvio(widget.token, context);
      envio.then((value) => _markedEnvios.clear());
      setState(() {});
    });
  }

  Future<void> _verifyToken(void Function() functionality) async {
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

  String alertContent(String verb) {
    String enviosId = 'Se $verb el siguiente envío:';

    _markedEnvios.forEach((element) {
      enviosId += '\n${element.idEnvio} - ${element.descCliente}';
    });

    return enviosId;
  }

  void _dropdownDialog(context) {

    DropdownMenu dropdownMenu = DropdownMenu();

    MyInformDialog(
      context: context,
      alertTitle: '¿Cuál fue el inconveniente?',
      alertContent: dropdownMenu,
      buttonText1: 'CANCELAR',
      buttonText2: 'INFORMAR',
      buttonAction1: () => Navigator.pop(context),
      buttonAction2: () {
        _informEnvio(dropdownMenu, context);
        setState(() {
          isButtonDisabled = true;          
        });
      },
      isButtonDisabled: isButtonDisabled,
    ).createDialog();
  }
}
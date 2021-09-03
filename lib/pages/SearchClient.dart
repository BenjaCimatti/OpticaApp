import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:laboratorio_elena/classes/ColorPalette.dart';
import 'package:laboratorio_elena/classes/Location.dart';
import 'package:laboratorio_elena/models/Client.dart';
import 'package:laboratorio_elena/models/ReturnId.dart';
import 'package:laboratorio_elena/models/Token.dart';
import 'package:laboratorio_elena/repository/ReturnIdRepository.dart';
import 'package:laboratorio_elena/repository/TokenRepository.dart';
import 'package:laboratorio_elena/widgets/MyAlertDialog.dart';
import 'package:laboratorio_elena/widgets/TrailingIcon.dart';
import 'dart:math' as math;

// ignore: must_be_immutable
class SearchClient extends StatefulWidget {

  List<Client> clientList;
  String baseUrl;
  String token;


  SearchClient({
    required this.clientList,
    required this.baseUrl,
    required this.token,
  });

  @override
  _SearchClientState createState() => _SearchClientState();
}

class _SearchClientState extends State<SearchClient> {

  final _markedClients = <Client>[];
  final List<Client> _searchedResults = [];

  late Future<ReturnId> returnId;
  late Future<Position> position;
  late Future<bool> isExpired;
  late Future<Token> renewedToken;

  late bool searching;
  bool _isloading = false;

  final TextEditingController _searchController = new TextEditingController();

  @override
  void initState() { 
    super.initState();
    searching = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette().getBluishGrey(),
      appBar: buildAppBar(context),
      body: _searchedResults.length != 0 ?
      ListView.builder(
        physics: AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics()
        ),
        itemCount: _searchedResults.length,
        itemBuilder: (context, index) {
          return _createListTile(_searchedResults[index]);
        }
      ) :
      ListView.builder(
        physics: AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics()
        ),
        itemCount: widget.clientList.length,
        itemBuilder: (context, index) {
          return _createListTile(widget.clientList[index]);
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isloading ? null : returnEnvioButton,
        backgroundColor: _isloading ? Colors.blueGrey : ColorPalette().getLightGreen(),
        elevation: 20,
        disabledElevation: 1,
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(math.pi),
          child: Icon(Icons.local_shipping, color: Colors.white,),
        ),
      ),
    );
  }

  Widget _createListTile(Client client) {
    final bool alreadyMarked = _markedClients.contains(client);

    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
      child: Card(
        elevation: 0,
        color: ColorPalette().getLightBlueishGrey(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: ListTile(
          trailing: alreadyMarked ? TrailingIcon(color: ColorPalette().getLightGreen()) : TrailingIcon(color: Colors.black.withOpacity(0),),
          isThreeLine: false,
          title: Text(
            client.descCliente,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              color: ColorPalette().getLightGreen()
            ),
          ),
          subtitle: Text(
            'Id de cliente: ${client.idCliente}',
            style: TextStyle(
              color: ColorPalette().getLightBlue(),
              fontWeight: FontWeight.w600
            ),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          onTap: () {
            setState(() {
            if(alreadyMarked) {
              _markedClients.remove(client);
            } else {
              _markedClients.clear();
              _markedClients.add(client);
            }          
            });
          },
        ),
      ),
    );
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

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
      backgroundColor: ColorPalette().getDarkBlueishGrey(),
      title: searching ? TextField(
        controller: _searchController,
        style: TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.only(top: 17),
          prefixIcon: Icon(Icons.search, color: Colors.white60),
          hintText: "Búsqueda...",
          hintStyle: TextStyle(color: Colors.white60)
        ),
        onChanged: searchOperation,
      ) : Text(
        'Seleccionar Cliente'
      ),
      actions: <Widget>[
        IconButton(
          icon: searching ? Icon(
            Icons.close,
            color: Colors.white,
          ) : Icon(
            Icons.search,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              if (searching) {
                searching = false;
                _searchedResults.clear();
              } else {
                searching = true;
                _searchController.clear();
              }
            });
          },
        ),
    ]);
  }

  Future<void> searchOperation(String text) async {
    print(text);
    _searchedResults.clear();
    widget.clientList.forEach((client) {
      if (searching) {
        if (client.descCliente.toLowerCase().contains(text.toLowerCase())) {
          setState(() {
            _searchedResults.add(client);
          });
        }
      }
    });
  }

  Future<void> returnEnvioButton() async {
    if (_markedClients.length > 0) {
      setState(() {
        _isloading = true;
      });
      _verifyToken(() {
        position = determinePosition(context);
        position.then((location) {
          var lat = location.latitude;
          var long = location.longitude;
          _markedClients.forEach((client) {
            print('${client.descCliente} ${client.idCliente}');
            returnId = ReturnIdRepository(baseUrl: widget.baseUrl).returnEnvio(client.idCliente, lat, long, widget.token, context);
            setState(() {});
            returnId.then((id) {
              print(id.idRetorno);
              MyDialog(
                context: context,
                alertTitle: 'Id del Envío: ${id.idRetorno}',
                alertContent: 'Identifique de alguna manera el envío (paquete, embalaje, etc) con el id ${id.idRetorno}',
                buttonText: 'ENTENDIDO',
                buttonAction: ()  {
                  setState(() {
                    _markedClients.clear();
                  });
                  Navigator.pop(context);
                },
              ).createDialog();
              setState(() {
                _isloading = false;
              });
            });
          });
        }); 
      });            
    } else {
      MyDialog(
        context: context,
        alertTitle: 'Ningún cliente seleccionado',
        alertContent: 'Por favor, seleccione el cliente desde el cual retorna un envío',
        buttonText: 'Ok',
        buttonAction: () => Navigator.pop(context)
      ).createDialog();
    }
  }

}
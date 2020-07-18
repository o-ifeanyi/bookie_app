import 'package:bookie/constants.dart';
import 'package:bookie/models/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderClass>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Column(
            children: <Widget>[
              SwitchListTile(
                title: Row(
                  children: <Widget>[
                    provider.getTheme() == kDarkTheme
                        ? Icon(FlutterIcons.moon_ent)
                        : Icon(Icons.lightbulb_outline),
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      provider.getTheme() == kDarkTheme
                          ? 'Dark Theme'
                          : 'Light Theme',
                      style: kSearchResultTextStyle,
                    ),
                  ],
                ),
                value: provider.getTheme() == kDarkTheme,
                onChanged: (bool newValue) async {
                  if (provider.getTheme() == kDarkTheme) {
                    Provider.of<ProviderClass>(context, listen: false)
                        .setTheme(kLightTheme);
                  } else {
                    Provider.of<ProviderClass>(context, listen: false)
                        .setTheme(kDarkTheme);
                  }
                  var pref = await SharedPreferences.getInstance();
                  pref.setBool('theme', provider.getTheme() == kDarkTheme);
                },
              ),
              Divider(
                thickness: 1,
              ),
              ListTile(
                dense: true,
                leading: Icon(Icons.delete_outline),
                title: Text(
                  'Delete downloads',
                  style: kSearchResultTextStyle,
                ),
                onTap: () {
                  displayDialog(
                    context: context,
                    title: 'downloads',
                    onPressed: () async{
                      await provider.clearDownloads();
                      Navigator.pop(context);
                    }
                  );
                },
              ),
              Divider(
                thickness: 1,
              ),
              ListTile(
                dense: true,
                leading: Icon(Icons.favorite_border),
                title: Text(
                  'Remove favourites',
                  style: kSearchResultTextStyle,
                ),
                onTap: () {
                  displayDialog(
                    context: context,
                    title: 'favourites',
                    onPressed: () async{
                      await provider.clearFavourites();
                      Navigator.pop(context);
                    }
                  );
                },
              ),
              Divider(
                thickness: 1,
              ),
              ListTile(
                dense: true,
                leading: Icon(Icons.info_outline),
                title: Text(
                  'About',
                  style: kSearchResultTextStyle,
                ),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AboutDialog(
                          applicationName: 'Bookie',
                          applicationVersion: '1.0',
                        );
                      });
                },
              ),
              Divider(
                thickness: 1,
              ),
            ],
          ),
        );
      },
    );
  }
}

displayDialog({BuildContext context, String title, Function onPressed}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Are you sure?'),
        content: Text(title == 'downloads'
            ? 'This would delete all downloaded books. Permernently!'
            : 'This would remove all favourite books. Permanently!'),
        actions: <Widget>[
          FlatButton(onPressed: onPressed, child: Text('Yes'),),
          FlatButton(onPressed: () => Navigator.pop(context), child: Text('No'),),
        ],
      );
    },
  );
}

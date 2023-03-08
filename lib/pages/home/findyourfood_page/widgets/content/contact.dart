import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Contact extends StatelessWidget {
  final String? instagramHandle;
  final String? website;
  final String? email;
  const Contact({
    Key? key,
    this.instagramHandle,
    this.website,
    this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        instagramHandle != null
            ? Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: InkWell(
                  onTap: () => launchUrl(Uri.parse(
                      'https://www.instagram.com/${instagramHandle!}')),
                  child: Container(
                    width: 30.0,
                    height: 30.0,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 5),
                        boxShadow: const [
                          BoxShadow(
                              blurRadius: 20,
                              color: Color.fromARGB(255, 224, 224, 224),
                              spreadRadius: 5)
                        ]),
                    child: const CircleAvatar(
                      radius: 40.0,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage('lib/assets/instagram.png'),
                    ),
                  ),
                ),
              )
            : Container(),
        website != null
            ? Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: InkWell(
                  onTap: () => launchUrl(Uri.parse('https://${website!}')),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 0),
                    child: Container(
                      width: 30.0,
                      height: 30.0,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          image: const DecorationImage(
                            image: AssetImage('lib/assets/website.png'),
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 7),
                          boxShadow: const [
                            BoxShadow(
                                blurRadius: 20,
                                color: Color.fromARGB(255, 231, 231, 231),
                                spreadRadius: 5)
                          ]),
                      child: const CircleAvatar(
                        radius: 50.0,
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage('lib/assets/website.png'),
                      ),
                    ),
                  ),
                ))
            : Container(),
        email != null
            ? Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: InkWell(
                  onTap: () => launchUrl(
                    Uri.parse('mailto:${email!}'),
                  ),
                  child: Container(
                    width: 30.0,
                    height: 30.0,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 5),
                        boxShadow: const [
                          BoxShadow(
                              blurRadius: 20,
                              color: Color.fromARGB(255, 224, 224, 224),
                              spreadRadius: 5)
                        ]),
                    child: const Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Image(
                        image: AssetImage('lib/assets/email.png'),
                      ),
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}

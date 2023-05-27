import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Connexion extends StatefulWidget {
  const Connexion({Key? key}) : super(key: key);

  @override
  State<Connexion> createState() => _ConnexionState();
}

class _ConnexionState extends State<Connexion> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();


  @override
  void dispose() {

    super.dispose();
    _passwordController.dispose();
    _emailController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/register.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [

              Container(
                // padding: const EdgeInsets.only(left: 35, top: 150, right: 35),
                child: const ImageIcon(
                  AssetImage('assets/logo.png'),
                  size: 350,
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  // top: MediaQuery.of(context).size.height * 0.55,
                  right: 35,
                  left: 35,
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.account_circle),
                        fillColor: Colors.transparent,
                        filled: true,
                        labelText: "Nom d'utilisateur",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 10,
                            color: Colors.cyanAccent,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 3,
                            color: Colors.cyanAccent,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.lock),
                        fillColor: Colors.transparent,
                        filled: true,
                        labelText: "Mot De Passe",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 3,
                            color: Colors.greenAccent,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 3,
                            color: Colors.cyanAccent,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    Text(
                      'Connection',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 27,
                        fontWeight: FontWeight.w900,
                        fontFamily: ' Open Sans',
                      ),
                    ),
                    SizedBox(height: 10),
                    IconButton(
                      onPressed: () async{
                        try {
                          await FirebaseAuth
                              .instance
                              .signInWithEmailAndPassword(
                              email: _emailController
                                  .text,
                              password:
                              _passwordController
                                  .text);

                          ScaffoldMessenger.of(
                              context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "Login Success, redirecting..."),
                            ),

                          );
                          Navigator.pushNamed(context, 'home');
                        } catch (e) {
                          ScaffoldMessenger.of(
                              context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "Incorrect email or password"),
                            ),
                          );
                        }
                      },
                      icon: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.black54,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Si vous avez oublié votre mot de passe, Contactez-nous',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: ' Open Sans',
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
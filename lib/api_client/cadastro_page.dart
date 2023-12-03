import 'dart:convert';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController ruaController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  final TextEditingController empresaController = TextEditingController();
  final TextEditingController cnpjController = TextEditingController();
  final TextEditingController enderecoController = TextEditingController();
  final TextEditingController emailempresaController = TextEditingController();

  Future<void> _registerUser(BuildContext context) async {
    try {
      String apiUrl = 'http://localhost:3000/cadastro';

      Map<String, dynamic> userData = {
        'email': emailController.text,
        'senha': senhaController.text,
        'cpf': cpfController.text,
        'tipo': currentTabIndex == 0 ? 'cadastro_pessoa' : 'cadastro_empresa',
        // Adicione outros campos conforme necessário
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );

      if (response.statusCode == 201) {
        // Cadastro bem-sucedido
        Navigator.of(context).pushReplacementNamed("L");
      } else if (response.statusCode == 400) {
        // E-mail já cadastrado
        setState(() {
          mensagemErro = 'E-mail já cadastrado.';
        });
      } else {
        // Erro desconhecido
        setState(() {
          mensagemErro = 'Erro ao cadastrar usuário.';
        });
      }
    } catch (error) {
      print('Erro ao cadastrar usuário: $error');
      setState(() {
        mensagemErro = 'Erro interno do aplicativo.';
      });
    }
  }

  String mensagemErro = '';
  int currentTabIndex = 0;

  final List<String> bairros = [
    'Bairro 1',
    'Bairro 2',
    'Bairro 3',
    'Bairro 4',
  ];

  String? selectedBairro;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: currentTabIndex,
    ); // Crie o TabController aqui

    _tabController.addListener(() {
      setState(() {
        currentTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: currentTabIndex,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/6.png",
                fit: BoxFit.cover,
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: 230,
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TabBar(
                    controller: _tabController,
                    tabs: [
                      Tab(
                        icon: Icon(
                          Icons.person,
                          color: Colors.green,
                        ),
                      ),
                      Tab(
                        icon: Icon(
                          Icons.business,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildCadastroPessoa(),
                      _buildCadastroEmpresa(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCadastroPessoa() {
    return SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding:
              const EdgeInsets.only(bottom: 10, left: 40, right: 40, top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTextField(emailController, "Email", Icons.email),
              SizedBox(height: 5),
              _buildTextField(
                  nomeController, "Nome Completo", Icons.account_box),
              SizedBox(height: 5),
              _buildNumericCpfTextField(
                  cpfController, "CPF (Somente números)", Icons.person),
              SizedBox(height: 5),
              _buildTextField(ruaController, "Rua(Rua, Nº e complemento)",
                  Icons.maps_home_work),
              SizedBox(height: 5),
              _buildBairroDropdown(),
              SizedBox(height: 5),
              _buildPasswordTextField(senhaController, "Senha"),
              SizedBox(height: 15),
              _buildRegisterButton(),
              SizedBox(
                height: 250,
              ),
              Text(
                mensagemErro,
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCadastroEmpresa() {
    return SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding:
              const EdgeInsets.only(bottom: 10, left: 40, right: 40, top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTextField(
                  emailempresaController, "Email da Empresa", Icons.email),
              SizedBox(height: 5),
              _buildTextField(
                  empresaController, "Nome da Empresa", Icons.business),
              SizedBox(height: 5),
              _buildNumericCnpjTextField(
                  cnpjController, "CNPJ", Icons.business),
              SizedBox(height: 5),
              _buildTextField(
                  enderecoController, "Endereço da Empresa", Icons.location_on),
              SizedBox(height: 5),
              _buildBairroDropdown(),
              SizedBox(height: 5),
              _buildPasswordTextField(senhaController, "Senha da Empresa"),
              SizedBox(height: 15),
              _buildRegisterButton(),
              SizedBox(
                height: 250,
              ),
              Text(
                mensagemErro,
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        suffixIcon: Icon(
          icon,
          color: Colors.grey.withOpacity(0.5),
        ),
      ),
    );
  }

  Widget _buildNumericCpfTextField(
      TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        CpfInputFormatter(),
      ],
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        suffixIcon: Icon(
          icon,
          color: Colors.grey.withOpacity(0.5),
        ),
      ),
    );
  }

  Widget _buildNumericCnpjTextField(
      TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        CnpjInputFormatter(),
      ],
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        suffixIcon: Icon(
          icon,
          color: Colors.grey.withOpacity(0.5),
        ),
      ),
    );
  }

  Widget _buildPasswordTextField(
      TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        suffixIcon: Icon(
          Icons.lock_rounded,
          color: Colors.grey.withOpacity(0.5),
        ),
      ),
    );
  }

  Widget _buildBairroDropdown() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: DropdownButton<String>(
          value: selectedBairro,
          isExpanded: true,
          items: bairros.map((String bairro) {
            return DropdownMenuItem<String>(
              value: bairro,
              child: Text(bairro),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedBairro = newValue;
            });
          },
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed: () {
        String cpf = cpfController.text;
        String cnpj = cnpjController.text;
        if (GetUtils.isCpf(cpf) || GetUtils.isCnpj(cnpj)) {
          _registerUser(context);
        }
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: Colors.green,
      ),
      child: Container(
        width: 100,
        height: 30,
        alignment: Alignment.center,
        child: Text(
          'Cadastrar',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void __registerUser(BuildContext context) {
    Navigator.of(context).pushReplacementNamed("L");
  }
}

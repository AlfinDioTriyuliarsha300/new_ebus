import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_ebus/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

import '../../../../providers/user_provider.dart';
import '../../../../providers/company_provider.dart';
import '../widgets/super_admin_sidebar.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final searchController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final createEmailController = TextEditingController();
  final createPasswordController = TextEditingController();
  final editEmailController = TextEditingController();

  String selectedRole = "Semua";
  String selectedCreateRole = "driver";

  int selectedCompanyId = 0;

  final List<String> roles = [
    "Semua",
    "super_admin",
    "admin_perusahaan",
    "driver",
    "penumpang",
    "agen",
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().getUsers();
    });
  }

  List<UserModel> getFilteredUsers(List<UserModel> users) {
    return users.where((user) {
      final searchMatch = user.email.toLowerCase().contains(
        searchController.text.toLowerCase(),
      );

      final roleMatch = selectedRole == "Semua"
          ? true
          : user.role == selectedRole;

      return searchMatch && roleMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SuperAdminSidebar(
            selectedMenu: 2,

            onMenuSelected: (menu) {
              switch (menu) {
                case 0:
                  context.go("/super-admin");
                  break;

                case 1:
                  context.go("/company-management");
                  break;

                case 2:
                  context.go("/user-management");
                  break;

                case 3:
                  context.go("/super-admin-report");
                  break;

                case 99:
                  context.go("/login");
                  break;
              }
            },
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),

              child: Consumer<UserProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final filteredUsers = getFilteredUsers(provider.users);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      const Text(
                        "Manajemen User",

                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: [

                          // SEARCH
                          Expanded(
                            child: TextField(
                              controller: searchController,
                              decoration: InputDecoration(
                                hintText: "Cari Email User",
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onChanged: (_) {
                                setState(() {});
                              },
                            ),
                          ),

                          const SizedBox(width: 15),

                          // FILTER ROLE
                          SizedBox(
                            width: 200,
                            child: DropdownButtonFormField<String>(
                              value: selectedRole,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              items: roles.map((role) {
                                return DropdownMenuItem(
                                  value: role,
                                  child: Text(role),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedRole = value!;
                                });
                              },
                            ),
                          ),

                          const SizedBox(width: 15),

                          SizedBox(
                            height: 50,
                            child: FilledButton.icon(
                              onPressed: () {
                                showCreateUserDialog();
                              },
                              icon: const Icon(Icons.add, size: 20),
                              label: const Text(
                                "Tambah User",
                                style: TextStyle(fontSize: 15),
                              ),
                              style: FilledButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),

                      const SizedBox(height: 20),

                      Expanded(
                        child: Card(
                          child: ListView.builder(
                            itemCount: filteredUsers.length,

                            itemBuilder: (context, index) {
                              final user = filteredUsers[index];

                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),

                                child: ListTile(
                                  leading: const CircleAvatar(
                                    child: Icon(Icons.person),
                                  ),

                                  title: Text(user.email),

                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,

                                    children: [
                                      Text("Role : ${user.role}"),

                                      Text(
                                        "Company ID : "
                                        "${user.companyId}",
                                      ),

                                      Text(
                                        "City ID : "
                                        "${user.cityId}",
                                      ),
                                    ],
                                  ),

                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [

                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.blue,
                                        ),
                                        onPressed: () {
                                          showEditUserDialog(user);
                                        },
                                      ),

                                      IconButton(
                                        icon: const Icon(
                                          Icons.lock_reset,
                                          color: Colors.orange,
                                        ),
                                        onPressed: () {
                                          showResetPasswordDialog(user);
                                        },
                                      ),

                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          showDeleteDialog(user);
                                        },
                                      ),

                                      Text(user.role),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showMessage({
    required String title,
    required String message,
    required IconData icon,
    required Color color,
  }) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 10),
              Expanded(child: Text(title)),
            ],
          ),

          content: Text(message),

          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void showResetPasswordDialog(UserModel user) {
    newPasswordController.clear();
    confirmPasswordController.clear();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            "Reset Password\n${user.email}",
          ),

          content: SizedBox(

            width: 420,

            child: Column(

              mainAxisSize: MainAxisSize.min,

              children: [

                TextField(

                  controller: newPasswordController,

                  obscureText: true,

                  decoration: const InputDecoration(
                    labelText: "Password Baru",
                  ),
                ),

                const SizedBox(height: 15),

                TextField(

                  controller: confirmPasswordController,

                  obscureText: true,

                  decoration: const InputDecoration(
                    labelText: "Konfirmasi Password",
                  ),
                ),
              ],
            ),
          ),

          actions: [

            TextButton(

              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text("Batal"),
            ),

            ElevatedButton(

              onPressed: () async {

                // PASSWORD KOSONG
                if (newPasswordController.text.isEmpty ||
                    confirmPasswordController.text.isEmpty) {

                  Navigator.pop(context);

                  showMessage(
                    title: "Peringatan",
                    message: "Password tidak boleh kosong.",
                    icon: Icons.warning,
                    color: Colors.orange,
                  );

                  return;
                }

                // PASSWORD TIDAK SAMA
                if (newPasswordController.text !=
                    confirmPasswordController.text) {

                  Navigator.pop(context);

                  showMessage(
                    title: "Peringatan",
                    message: "Konfirmasi password tidak sama.",
                    icon: Icons.warning,
                    color: Colors.orange,
                  );

                  return;
                }

                try {

                  await context.read<UserProvider>().resetPassword(

                    user.id,

                    newPasswordController.text,

                  );

                  if (!mounted) return;

                  Navigator.pop(context);

                  showMessage(

                    title: "Berhasil",

                    message: "Password berhasil diubah.",

                    icon: Icons.check_circle,

                    color: Colors.green,

                  );

                } catch (e) {

                  if (!mounted) return;

                  Navigator.pop(context);

                  showMessage(

                    title: "Gagal",

                    message: e.toString(),

                    icon: Icons.cancel,

                    color: Colors.red,

                  );
                }
              },

              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  void showCreateUserDialog() {
    createEmailController.clear();
    createPasswordController.clear();

    selectedCreateRole = "driver";
    selectedCompanyId = 0;

    context.read<CompanyProvider>().getCompanies();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Tambah User"),
              content: SizedBox(
                width: 450,
                child: Consumer<CompanyProvider>(
                  builder: (context, companyProvider, child) {

                    if (companyProvider.isLoading) {
                      return const SizedBox(
                        width: 450,
                        height: 150,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: createEmailController,
                          decoration: const InputDecoration(
                            labelText: "Email",
                          ),
                        ),

                        const SizedBox(height: 15),

                        TextField(
                          controller: createPasswordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: "Password",
                          ),
                        ),

                        const SizedBox(height: 15),

                        DropdownButtonFormField<String>(
                          value: selectedCreateRole,
                          decoration: const InputDecoration(
                            labelText: "Role",
                          ),

                          items: const [
                            DropdownMenuItem(
                              value: "driver",
                              child: Text("Driver"),
                            ),

                            DropdownMenuItem(
                              value: "penumpang",
                              child: Text("Penumpang"),
                            ),

                            DropdownMenuItem(
                              value: "admin_perusahaan",
                              child: Text("Admin Perusahaan"),
                            ),

                            DropdownMenuItem(
                              value: "agen",
                              child: Text("Agen"),
                            ),
                          ],

                          onChanged: (v){
                            setStateDialog((){
                              selectedCreateRole = v!;
                            });
                          },
                        ),

                        if (selectedCreateRole == "admin_perusahaan") ...[

                          const SizedBox(height: 15),

                          DropdownButtonFormField<int>(

                            value: selectedCompanyId,

                            decoration: const InputDecoration(
                              labelText: "Perusahaan",
                            ),

                            items: [

                              const DropdownMenuItem(
                                value: 0,
                                child: Text("Pilih Perusahaan"),
                              ),

                              ...companyProvider.companies.map(
                                (company) {

                                  return DropdownMenuItem<int>(

                                    value: company.id,

                                    child: Text(company.companyName),
                                  );
                                },
                              ),

                            ],

                            onChanged: (value) {

                              setStateDialog(() {

                                selectedCompanyId = value ?? 0;

                              });

                            },
                          ),
                        ]
                      ],
                    );
                  },
                ),
              ),

              actions: [
                TextButton(
                  onPressed: (){
                    Navigator.pop(dialogContext);
                  },
                  child: const Text("Batal"),
                ),

                ElevatedButton(
                  onPressed: () async {
                    if(createEmailController.text.isEmpty ||
                        createPasswordController.text.isEmpty){
                      showMessage(
                        title:"Peringatan",
                        message:"Semua field wajib diisi",
                        icon:Icons.warning,
                        color:Colors.orange,
                      );
                      return;
                    }

                    try{
                      await context.read<UserProvider>().createUser(
                        email: createEmailController.text,
                        password: createPasswordController.text,
                        role: selectedCreateRole,
                        companyId: selectedCompanyId,
                      );

                      if(!mounted) return;

                      Navigator.pop(dialogContext);

                      showMessage(
                        title:"Berhasil",
                        message:"User berhasil ditambahkan",
                        icon:Icons.check_circle,
                        color:Colors.green,
                      );

                    }catch(e){

                      showMessage(
                        title:"Gagal",
                        message:e.toString(),
                        icon:Icons.cancel,
                        color:Colors.red,
                      );
                    }
                  },
                  child: const Text("Simpan"),
                )
              ],
            );
          },
        );
      },
    );
  }

  void showEditUserDialog(UserModel user) {
    editEmailController.text = user.email;
    selectedCreateRole = user.role;
    selectedCompanyId = user.companyId;
    context.read<CompanyProvider>().getCompanies();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Edit User"),
              content: SizedBox(
                width: 450,
                child: Consumer<CompanyProvider>(
                  builder: (context, companyProvider, child) {
                    if (companyProvider.isLoading) {
                      return const SizedBox(
                        height: 150,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: editEmailController,
                          decoration: const InputDecoration(
                            labelText: "Email",
                          ),
                        ),

                        const SizedBox(height: 15),

                        DropdownButtonFormField<String>(
                          value: selectedCreateRole,
                          decoration: const InputDecoration(
                            labelText: "Role",
                          ),

                          items: const [
                            DropdownMenuItem(
                              value: "driver",
                              child: Text("Driver"),
                            ),

                            DropdownMenuItem(
                              value: "penumpang",
                              child: Text("Penumpang"),
                            ),

                            DropdownMenuItem(
                              value: "admin_perusahaan",
                              child: Text("Admin Perusahaan"),
                            ),

                            DropdownMenuItem(
                              value: "agen",
                              child: Text("Agen"),
                            ),
                          ],

                          onChanged: (value) {
                            setStateDialog(() {
                              selectedCreateRole = value!;
                            });
                          },
                        ),

                        if (selectedCreateRole == "admin_perusahaan") ...[
                          const SizedBox(height: 15),
                          DropdownButtonFormField<int>(
                            value: selectedCompanyId,
                            decoration: const InputDecoration(
                              labelText: "Perusahaan",
                            ),

                            items: [
                              const DropdownMenuItem(
                                value: 0,
                                child: Text("Pilih Perusahaan"),
                              ),

                              ...companyProvider.companies.map(
                                (company) {
                                  return DropdownMenuItem(
                                    value: company.id,
                                    child: Text(company.companyName),
                                  );
                                },
                              ),
                            ],

                            onChanged: (value) {
                              setStateDialog(() {
                                selectedCompanyId = value ?? 0;
                              });
                            },
                          ),
                        ]
                      ],
                    );
                  },
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text("Batal"),
                ),

                FilledButton(
                  onPressed: () async {
                    try {
                      await context.read<UserProvider>().updateUser(
                        id: user.id,
                        email: editEmailController.text,
                        role: selectedCreateRole,
                        companyId: selectedCompanyId,
                      );

                      if (!mounted) return;

                      Navigator.pop(dialogContext);

                      showMessage(
                        title: "Berhasil",
                        message: "User berhasil diupdate",
                        icon: Icons.check_circle,
                        color: Colors.green,
                      );

                    } catch (e) {

                      showMessage(
                        title: "Gagal",
                        message: e.toString(),
                        icon: Icons.cancel,
                        color: Colors.red,
                      );
                    }
                  },
                  child: const Text("Simpan"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void showDeleteDialog(UserModel user) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(

          title: const Text(
            "Hapus User",
          ),

          content: Text(
            "Yakin ingin menghapus\n${user.email} ?",
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Batal",
              ),
            ),

            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
              ),

              onPressed: () async {
                try {
                  await context
                      .read<UserProvider>()
                      .deleteUser(user.id);

                  if (!mounted) return;

                  Navigator.pop(context);

                  showMessage(
                    title: "Berhasil",
                    message: "User berhasil dihapus",
                    icon: Icons.check_circle,
                    color: Colors.green,
                  );

                } catch (e) {

                  Navigator.pop(context);

                  showMessage(
                    title: "Gagal",
                    message: e.toString(),
                    icon: Icons.cancel,
                    color: Colors.red,
                  );
                }
              },
              child: const Text(
                "Hapus",
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    searchController.dispose();

    newPasswordController.dispose();
    confirmPasswordController.dispose();

    createEmailController.dispose();
    createPasswordController.dispose();

    editEmailController.dispose();

    super.dispose();
  }
}

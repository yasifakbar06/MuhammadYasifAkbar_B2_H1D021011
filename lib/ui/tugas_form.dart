import 'package:flutter/material.dart';
import 'package:manejementugas/bloc/tugas_bloc.dart';
import 'package:manejementugas/model/tugas.dart';
import 'package:manejementugas/ui/tugas_page.dart';

class TugasForm extends StatefulWidget {
  final Tugas? tugas;

  TugasForm({Key? key, this.tugas}) : super(key: key);

  @override
  _TugasFormState createState() => _TugasFormState();
}

class _TugasFormState extends State<TugasForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String judul = "TAMBAH TUGAS";
  String tombolSubmit = "SIMPAN";

  final _titleTugasTextboxController = TextEditingController();
  final _descriptionTugasTextboxController = TextEditingController();
  final _deadlineTextboxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isUpdate();
  }

  isUpdate() {
    if (widget.tugas != null) {
      setState(() {
        judul = "UBAH TUGAS";
        tombolSubmit = "UBAH";
        _titleTugasTextboxController.text = widget.tugas!.title!;
        _descriptionTugasTextboxController.text = widget.tugas!.description!;
        _deadlineTextboxController.text = widget.tugas!.deadline.toString();
      });
    } else {
      judul = "TAMBAH TUGAS";
      tombolSubmit = "SIMPAN";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(judul)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _titleTugasTextField(),
                _descriptionTugasTextField(),
                _deadlineTextField(),
                _buttonSubmit(),
                if (widget.tugas != null)
                  _buttonDelete(), // Tambah tombol hapus jika sedang mengubah tugas
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _titleTugasTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "title Tugas"),
      keyboardType: TextInputType.text,
      controller: _titleTugasTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "title Tugas harus diisi";
        }
        return null;
      },
    );
  }

  Widget _descriptionTugasTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "description Tugas"),
      keyboardType: TextInputType.text,
      controller: _descriptionTugasTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "description Tugas harus diisi";
        }
        return null;
      },
    );
  }

  Widget _deadlineTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Deadline"),
      keyboardType: TextInputType.text,
      controller: _deadlineTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Deadline harus diisi";
        }
        return null;
      },
    );
  }

  Widget _buttonSubmit() {
    return OutlinedButton(
      child: Text(tombolSubmit),
      onPressed: () {
        var validate = _formKey.currentState!.validate();
        if (validate) {
          if (!_isLoading) {
            if (widget.tugas != null) {
              ubah();
            } else {
              simpan();
            }
          }
        }
      },
    );
  }

  Widget _buttonDelete() {
    return OutlinedButton(
      child: Text("HAPUS"),
      onPressed: () {
        if (widget.tugas != null) {
          hapus();
        }
      },
    );
  }

  simpan() {
    setState(() {
      _isLoading = true;
    });
    Tugas createTugas = Tugas(id: null);
    createTugas.title = _titleTugasTextboxController.text;
    createTugas.description = _descriptionTugasTextboxController.text;
    createTugas.deadline = _deadlineTextboxController.text;
    TugasBloc.addTugas(tugas: createTugas).then((value) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => const TugasPage(),
      ));
    }, onError: (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text("Simpan gagal, silahkan coba lagi"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });
    setState(() {
      _isLoading = false;
    });
  }

  ubah() {
    setState(() {
      _isLoading = true;
    });
    Tugas updateTugas = Tugas(id: widget.tugas!.id);
    updateTugas.title = _titleTugasTextboxController.text;
    updateTugas.description = _descriptionTugasTextboxController.text;
    updateTugas.deadline = _deadlineTextboxController.text;
    TugasBloc.updateTugas(tugas: updateTugas).then((value) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => const TugasPage(),
      ));
    }, onError: (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text("Permintaan ubah data gagal, silahkan coba lagi"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });
    setState(() {
      _isLoading = false;
    });
  }

  hapus() {
    if (widget.tugas != null) {
      setState(() {
        _isLoading = true;
      });

      TugasBloc.deleteTugas(id: widget.tugas!.id).then((value) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => const TugasPage(),
        ));
      }, onError: (error) {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            content: Text("Permintaan hapus data gagal, silahkan coba lagi"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      });
      setState(() {
        _isLoading = false;
      });
    }
  }
}
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void main() {
  runApp(const MiAplicacion());
}

class MiAplicacion extends StatelessWidget {
  const MiAplicacion({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Escaner QR',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const EscanerQR(),
    );
  }
}

class EscanerQR extends StatefulWidget {
  const EscanerQR({super.key});

  @override
  State<EscanerQR> createState() => _EscanerQRState();
}

class _EscanerQRState extends State<EscanerQR> {
  String resultado = 'Esperando codigo QR...';
  bool codigoLeido = false;

  final MobileScannerController controlador = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  void detectarQR(BarcodeCapture captura) {
    if (codigoLeido) return;

    for (final codigo in captura.barcodes) {
      final texto = codigo.rawValue;

      if (texto != null && texto.isNotEmpty) {
        setState(() {
          resultado = texto;
          codigoLeido = true;
        });

        controlador.stop();
        break;
      }
    }
  }

  void escanearNuevamente() {
    setState(() {
      resultado = 'Esperando codigo QR...';
      codigoLeido = false;
    });

    controlador.start();
  }

  @override
  void dispose() {
    controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Escaner QR'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Apunta la camara hacia un codigo QR',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: MobileScanner(
                  controller: controlador,
                  onDetect: detectarQR,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Resultado:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SelectableText(
              resultado,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: escanearNuevamente,
              child: const Text('Escanear otro QR'),
            ),
          ],
        ),
      ),
    );
  }
}

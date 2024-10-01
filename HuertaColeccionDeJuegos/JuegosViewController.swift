import UIKit

class JuegosViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tituloTextField: UITextField!
    @IBOutlet weak var agregarActualizarBoton: UIButton!
    @IBOutlet weak var eliminarBoton: UIButton!
    @IBOutlet weak var categoriaPickerView: UIPickerView!

    var imagePicker = UIImagePickerController()
    var juego: Juego? = nil

    let categorias = ["Acción", "Aventura", "Puzzle", "Deportes", "Estrategia"]

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        categoriaPickerView.dataSource = self
        categoriaPickerView.delegate = self

        if let juego = juego {
            imageView.image = UIImage(data: (juego.imagen!) as Data)
            tituloTextField.text = juego.titulo
            if let categoria = juego.categoria {
                if let index = categorias.firstIndex(of: categoria) {
                    categoriaPickerView.selectRow(index, inComponent: 0, animated: false)
                }
            }
            agregarActualizarBoton.setTitle("Actualizar", for: .normal)
        } else {
            eliminarBoton.isHidden = true
        }
    }

    @IBAction func fotosTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func camaraTapped(_ sender: Any) {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func agregarTapped(_ sender: Any) {
        let categoriaSeleccionada = categorias[categoriaPickerView.selectedRow(inComponent: 0)]

        if let juego = juego {
            juego.titulo = tituloTextField.text
            juego.imagen = imageView.image?.jpegData(compressionQuality: 0.50)
            juego.categoria = categoriaSeleccionada
        } else {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let juego = Juego(context: context)
            juego.titulo = tituloTextField.text
            juego.imagen = imageView.image?.jpegData(compressionQuality: 0.50)
            juego.categoria = categoriaSeleccionada
        }

        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController?.popViewController(animated: true)
    }

    @IBAction func eliminarTapped(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        if let juego = juego {
            context.delete(juego)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
        navigationController?.popViewController(animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let imagenSeleccionada = info[.originalImage] as? UIImage
        imageView.image = imagenSeleccionada
        imagePicker.dismiss(animated: true, completion: nil)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categorias.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categorias[row]
    }
}

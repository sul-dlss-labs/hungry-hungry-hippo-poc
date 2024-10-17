import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    patch() {
        // Replace the filename (which is only the base filename) with the full path.
        // There is no constructor for a FileList, so cheat by creating a DataTransfer object.
        const dataTransfer = new DataTransfer();
        for (const file of this.element.files) {
            const newFile = new File([file], file.webkitRelativePath, {type: file.type});
            // Add your file to the file list of the object
            dataTransfer.items.add(newFile);
        } 
        this.element.files = dataTransfer.files;
    }
}
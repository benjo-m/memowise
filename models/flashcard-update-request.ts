import { ImageFile } from "@/helpers/image-file";

export class FlashcardUpdateRequest {
  front: string;
  back: string;
  front_image_file: ImageFile;
  back_image_file: ImageFile;
  remove_front_image: boolean;
  remove_back_image: boolean;

  constructor({
    front,
    back,
    front_image_file,
    back_image_file,
    remove_front_image = false,
    remove_back_image = false,
  }: {
    front: string;
    back: string;
    front_image_file: ImageFile;
    back_image_file: ImageFile;
    remove_front_image?: boolean;
    remove_back_image?: boolean;
  }) {
    this.front = front;
    this.back = back;
    this.front_image_file = front_image_file;
    this.back_image_file = back_image_file;
    this.remove_front_image = remove_front_image;
    this.remove_back_image = remove_back_image;
  }
}

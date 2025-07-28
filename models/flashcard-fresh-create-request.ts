import { ImageFile } from "../helpers/image-file";

export class FlashcardFreshCreateRequest {
  front: string;
  back: string;
  front_image_file: ImageFile;
  back_image_file: ImageFile;

  constructor(front: string, back: string, frontImageFile: ImageFile, backImageFile: ImageFile) {
    this.front = front;
    this.back = back;
    this.front_image_file = frontImageFile;
    this.back_image_file = backImageFile;
  }
}

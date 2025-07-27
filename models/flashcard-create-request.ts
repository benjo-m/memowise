import { ImageFile } from "./image-file";

export class FlashcardCreateRequest {
  deckId: number;
  front: string;
  back: string;
  front_image_file: ImageFile;
  back_image_file: ImageFile;

  constructor(
    deckId: number,
    front: string,
    back: string,
    frontImageFile: ImageFile,
    backImageFile: ImageFile
  ) {
    this.deckId = deckId;
    this.front = front;
    this.back = back;
    this.front_image_file = frontImageFile;
    this.back_image_file = backImageFile;
  }
}

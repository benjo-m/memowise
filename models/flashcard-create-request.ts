import { ImageFile } from "../helpers/image-file";

export class FlashcardCreateRequest {
  deckId: number;
  front: string;
  back: string;
  front_image_file: ImageFile | null;
  back_image_file: ImageFile | null;

  constructor(
    deckId: number,
    front: string,
    back: string,
    frontImageFile: ImageFile | null,
    backImageFile: ImageFile | null
  ) {
    this.deckId = deckId;
    this.front = front;
    this.back = back;
    this.front_image_file = frontImageFile;
    this.back_image_file = backImageFile;
  }
}

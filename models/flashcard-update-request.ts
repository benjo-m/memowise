export class FlashcardUpdateRequest {
  front: string;
  back: string;

  constructor(front: string, back: string) {
    this.front = front;
    this.back = back;
  }
}

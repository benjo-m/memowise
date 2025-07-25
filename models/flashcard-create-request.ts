export class FlashcardCreateRequest {
  deck_id: number;
  front: string;
  back: string;

  constructor(deck_id: number, front: string, back: string) {
    this.deck_id = deck_id;
    this.front = front;
    this.back = back;
  }
}

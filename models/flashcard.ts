export type Flashcard = {
  id: string;
  deck_id: string;
  front: string;
  back: string;
  front_image_url: string;
  back_image_url: string;
  interval: number;
  repetitions: number;
  ease_factor: number;
  due_date: Date;
};

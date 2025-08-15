export type Flashcard = {
  id: number;
  deck_id: number;
  front: string;
  back: string;
  front_image_url: string | null;
  back_image_url: string | null;
  interval: number;
  repetitions: number;
  ease_factor: number;
  due_date: Date;
  due_today: boolean;
};

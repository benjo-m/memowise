export class TodaysProgress {
  id: number;
  user_id: number;
  flashcards_due_today_count: number;
  flashcards_reviewed_today_count: number;
  progress_date: Date;

  constructor(data: {
    id: number;
    user_id: number;
    flashcards_due_today_count: number;
    flashcards_reviewed_today_count: number;
    progress_date: string;
  }) {
    this.id = data.id;
    this.user_id = data.user_id;
    this.flashcards_due_today_count = data.flashcards_due_today_count;
    this.flashcards_reviewed_today_count = data.flashcards_reviewed_today_count;
    this.progress_date = new Date(data.progress_date);
  }
}

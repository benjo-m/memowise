export class StudySessionCreateRequest {
  deck_id: number;
  duration: number;
  correct_answers: number;
  incorrect_answers: number;

  constructor({
    deck_id,
    duration,
    correct_answers,
    incorrect_answers,
  }: {
    deck_id: number;
    duration: number;
    correct_answers: number;
    incorrect_answers: number;
  }) {
    this.deck_id = deck_id;
    this.duration = duration;
    this.correct_answers = correct_answers;
    this.incorrect_answers = incorrect_answers;
  }
}

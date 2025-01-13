using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace api.Migrations
{
    /// <inheritdoc />
    public partial class MoveCardsRatedXToStudySession : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "CardsRated1",
                table: "UserStats");

            migrationBuilder.DropColumn(
                name: "CardsRated2",
                table: "UserStats");

            migrationBuilder.DropColumn(
                name: "CardsRated3",
                table: "UserStats");

            migrationBuilder.DropColumn(
                name: "CardsRated4",
                table: "UserStats");

            migrationBuilder.DropColumn(
                name: "CardsRated5",
                table: "UserStats");

            migrationBuilder.AddColumn<int>(
                name: "CardsRated1",
                table: "StudySessions",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "CardsRated2",
                table: "StudySessions",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "CardsRated3",
                table: "StudySessions",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "CardsRated4",
                table: "StudySessions",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "CardsRated5",
                table: "StudySessions",
                type: "int",
                nullable: false,
                defaultValue: 0);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "CardsRated1",
                table: "StudySessions");

            migrationBuilder.DropColumn(
                name: "CardsRated2",
                table: "StudySessions");

            migrationBuilder.DropColumn(
                name: "CardsRated3",
                table: "StudySessions");

            migrationBuilder.DropColumn(
                name: "CardsRated4",
                table: "StudySessions");

            migrationBuilder.DropColumn(
                name: "CardsRated5",
                table: "StudySessions");

            migrationBuilder.AddColumn<int>(
                name: "CardsRated1",
                table: "UserStats",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "CardsRated2",
                table: "UserStats",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "CardsRated3",
                table: "UserStats",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "CardsRated4",
                table: "UserStats",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "CardsRated5",
                table: "UserStats",
                type: "int",
                nullable: false,
                defaultValue: 0);
        }
    }
}

using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace api.Migrations
{
    /// <inheritdoc />
    public partial class AddImagesToCards : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "Image",
                table: "Cards",
                newName: "QuestionImage");

            migrationBuilder.AddColumn<byte[]>(
                name: "AnswerImage",
                table: "Cards",
                type: "varbinary(max)",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "AnswerImage",
                table: "Cards");

            migrationBuilder.RenameColumn(
                name: "QuestionImage",
                table: "Cards",
                newName: "Image");
        }
    }
}

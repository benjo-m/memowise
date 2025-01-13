using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace api.Migrations
{
    /// <inheritdoc />
    public partial class AddUserIdToStudySession : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "FirebaseUserUid",
                table: "StudySessions");

            migrationBuilder.AddColumn<int>(
                name: "UserId",
                table: "StudySessions",
                type: "int",
                nullable: false,
                defaultValue: 0);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "UserId",
                table: "StudySessions");

            migrationBuilder.AddColumn<string>(
                name: "FirebaseUserUid",
                table: "StudySessions",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");
        }
    }
}

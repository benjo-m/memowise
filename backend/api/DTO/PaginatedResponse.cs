namespace api.DTO;
public class PaginatedResponse<T>
{
    public List<T> Data { get; }
    public int PageIndex { get; }
    public int TotalPages { get; }
    public bool HasPreviousPage => PageIndex > 1;
    public bool HasNextPage => PageIndex < TotalPages;

    public PaginatedResponse(List<T> items, int pageIndex, int totalPages)
    {
        Data = items;
        PageIndex = pageIndex;
        TotalPages = totalPages;
    }
}
export default function TeacherLoading() {
  return (
    <div className="flex flex-col gap-6 animate-pulse">
      <div className="h-10 bg-gray-200 rounded-xl w-56" />
      <div className="card">
        <div className="h-6 bg-gray-200 rounded w-40 mb-3" />
        <div className="h-4 bg-gray-100 rounded w-full mb-2" />
        <div className="h-4 bg-gray-100 rounded w-3/4" />
      </div>
      <div className="card">
        <div className="h-6 bg-gray-200 rounded w-48 mb-3" />
        <div className="h-4 bg-gray-100 rounded w-full mb-2" />
        <div className="h-4 bg-gray-100 rounded w-1/2" />
      </div>
    </div>
  );
}

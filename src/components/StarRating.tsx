"use client";

interface StarRatingProps {
  value: number;
  onChange?: (value: number) => void;
  readonly?: boolean;
  size?: "sm" | "md" | "lg";
}

export default function StarRating({
  value,
  onChange,
  readonly = false,
  size = "md",
}: StarRatingProps) {
  const sizeClass = size === "sm" ? "text-xl" : size === "lg" ? "text-4xl" : "text-3xl";

  return (
    <div className="flex gap-1">
      {[1, 2, 3, 4, 5].map((star) => (
        <button
          key={star}
          type="button"
          disabled={readonly}
          onClick={() => onChange?.(star)}
          className={`${sizeClass} transition-transform ${
            !readonly ? "hover:scale-110 active:scale-95 cursor-pointer" : "cursor-default"
          }`}
          aria-label={`${star} ster${star > 1 ? "ren" : ""}`}
        >
          {star <= value ? "⭐" : "☆"}
        </button>
      ))}
    </div>
  );
}

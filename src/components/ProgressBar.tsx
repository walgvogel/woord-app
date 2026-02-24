interface ProgressBarProps {
  value: number; // 0–100
  label?: string;
  showPercent?: boolean;
  color?: "pink" | "blue";
}

export default function ProgressBar({
  value,
  label,
  showPercent = true,
  color = "pink",
}: ProgressBarProps) {
  const clampedValue = Math.min(100, Math.max(0, value));
  const barColor =
    color === "pink" ? "bg-pink" : "bg-brand-blue";

  return (
    <div className="w-full">
      {(label || showPercent) && (
        <div className="flex justify-between items-center mb-1">
          {label && (
            <span className="text-sm font-semibold text-gray-700">{label}</span>
          )}
          {showPercent && (
            <span className="text-sm font-bold text-gray-600">
              {Math.round(clampedValue)}%
            </span>
          )}
        </div>
      )}
      <div className="w-full bg-gray-200 rounded-full h-3 overflow-hidden">
        <div
          className={`${barColor} h-3 rounded-full transition-all duration-500 ease-out`}
          style={{ width: `${clampedValue}%` }}
        />
      </div>
    </div>
  );
}

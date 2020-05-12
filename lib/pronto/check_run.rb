module Pronto
  CheckRun = Struct.new(:sha, :name, :conclusion, :description, :annotations) do
    def ==(other)
      sha == other.sha &&
        name == other.name &&
        conclusion == other.conclusion &&
        description == other.description &&
        annotations == other.annotations
    end

    def to_s
      "[#{sha}] #{name} #{conclusion} - #{description}"
    end
  end
end

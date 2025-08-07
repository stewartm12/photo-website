"use client";

import type { KeyboardEvent } from "react";
import { useRef, useState, useCallback } from "react";
import { X } from "lucide-react";
import { Badge } from "@/components/ui/badge";
import {
  Command,
  CommandGroup,
  CommandItem,
  CommandList,
} from "@/components/ui/command";
import { Command as CommandPrimitive } from "cmdk";

type DefaultOptions = Record<"value" | "label", string>;
type OnChangeFunction = (value: string[]) => void;
type Placeholder = string;

type MultiSelectProps = {
  defaultOptions: DefaultOptions[];
  onChange: OnChangeFunction;
  placeholder: Placeholder;
}

export default function MultiSelect({ defaultOptions, onChange, placeholder }: MultiSelectProps) {
  const inputRef = useRef<HTMLInputElement>(null);
  const [open, setOpen] = useState(false);
  const [selected, setSelected] = useState<DefaultOptions[]>([]);
  const [inputValue, setInputValue] = useState("");

  const handleStateSelection = (option: string) => {
    const selectedIds = [...selected.map((s) => s.value), option];
    onChange(selectedIds);
  }

  const handleStateUnselection = useCallback(
    (option: string) => {
      const newSelected = selected.filter((s) => s.value !== option);
      onChange(newSelected.map((s) => s.value));
    },
    [selected, onChange]
  );

  const handleUnselect = useCallback((option: DefaultOptions) => {
    setSelected((prev) => prev.filter((s) => s.value !== option.value));
    handleStateUnselection(option.value);
  }, [handleStateUnselection]);

  const handleKeyDown = useCallback(
    (e: KeyboardEvent<HTMLDivElement>) => {
      const input = inputRef.current;
      if (input) {
        if (e.key === "Delete" || e.key === "Backspace") {
          if (input.value === "") {
            setSelected((prev) => {
              const newSelected = [...prev];
              newSelected.pop();
              return newSelected;
            });
          }
        }

        if (e.key === "Escape") {
          input.blur();
        }
      }
    },
    [],
  );

  const selectables = defaultOptions.filter(
    (defaultOption) => !selected.some((s) => s.value === defaultOption.value)
  );

  return (
    <Command
      onKeyDown={handleKeyDown}
      className="overflow-visible bg-transparent"
    >
      <div className="group rounded-md border border-input px-3 py-2 text-sm ring-offset-background focus-within:ring-2 focus-within:ring-ring focus-within:ring-offset-2">
        <div className="flex flex-wrap gap-1">
          {selected.map((option) => {
            return (
              <Badge key={option.value} variant="secondary">
                {option.label}
                <button
                  className="ml-1 rounded-full outline-none ring-offset-background focus:ring-2 focus:ring-ring focus:ring-offset-2"
                  onKeyDown={(e) => {
                    if (e.key === "Enter") {
                      handleUnselect(option);
                    }
                  }}
                  onMouseDown={(e) => {
                    e.preventDefault();
                    e.stopPropagation();
                  }}
                  onClick={() => handleUnselect(option)}
                >
                  <X className="h-3 w-3 text-muted-foreground hover:text-foreground" />
                </button>
              </Badge>
            );
          })}
          <CommandPrimitive.Input
            ref={inputRef}
            value={inputValue}
            onValueChange={setInputValue}
            onBlur={() => setOpen(false)}
            onFocus={() => setOpen(true)}
            placeholder={placeholder}
            className="ml-2 flex-1 bg-transparent outline-none placeholder:text-muted-foreground"
          />
        </div>
      </div>
      <div className="relative mt-2">
        <CommandList>
          {open && selectables.length > 0 ? (
            <div className="absolute top-0 z-10 w-full rounded-md border bg-popover text-popover-foreground shadow-md outline-none animate-in">
              <CommandGroup className="h-full overflow-auto">
                {selectables.map((option) => {
                  return (
                    <CommandItem
                      key={option.value}
                      value={option.value}
                      onMouseDown={(e) => {
                        e.preventDefault();
                        e.stopPropagation();
                      }}
                      onSelect={(value) => {
                        setInputValue("");
                        setSelected((prev) => [...prev, option]);
                        handleStateSelection(value);
                      }}
                      className={"cursor-pointer"}
                    >
                      {option.label}
                    </CommandItem>
                  );
                })}
              </CommandGroup>
            </div>
          ) : null}
        </CommandList>
      </div>
    </Command>
  );
};

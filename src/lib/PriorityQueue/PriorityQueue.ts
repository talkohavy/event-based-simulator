/**
 * Min-heap priority queue — used as the Future Event List.
 * Events with the smallest time are dequeued first.
 */
export class PriorityQueue<T> {
  private readonly heap: T[];

  constructor(private readonly compare: (a: T, b: T) => number) {
    this.heap = [];
  }

  get size(): number {
    return this.heap.length;
  }

  isEmpty(): boolean {
    return this.heap.length === 0;
  }

  peek(): T | undefined {
    return this.heap[0];
  }

  enqueue(item: T): void {
    this.heap.push(item);
    this.bubbleUp(this.heap.length - 1);
  }

  dequeue(): T | undefined {
    if (this.heap.length === 0) return undefined;

    const top = this.heap[0];
    const last = this.heap.pop()!;

    if (this.heap.length > 0) {
      this.heap[0] = last;
      this.sinkDown(0);
    }

    return top;
  }

  private bubbleUp(index: number): void {
    while (index > 0) {
      const parent = (index - 1) >> 1;

      if (this.compare(this.heap[index]!, this.heap[parent]!) >= 0) break;

      const temp = this.heap[index]!;
      this.heap[index] = this.heap[parent]!;
      this.heap[parent] = temp;
      index = parent;
    }
  }

  private sinkDown(index: number): void {
    const length = this.heap.length;

    while (true) {
      let smallest = index;
      const left = 2 * index + 1;
      const right = 2 * index + 2;

      if (left < length && this.compare(this.heap[left]!, this.heap[smallest]!) < 0) smallest = left;

      if (right < length && this.compare(this.heap[right]!, this.heap[smallest]!) < 0) smallest = right;

      if (smallest === index) break;

      const temp = this.heap[index]!;
      this.heap[index] = this.heap[smallest]!;
      this.heap[smallest] = temp;
      index = smallest;
    }
  }
}

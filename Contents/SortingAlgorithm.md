---
title: Sorting Algorithm
date: 2020-05-03 11:20:45
categories: 
- Algorithm
tags: 
- Sorting
---



# Sorting Algorithm

<a name="f4290ac6"></a>
# 1. Overview

<a name="d21706f1"></a>
## 1.1. Classification

排序算法分为内部排序和外部排序，内部排序把数据记录放在内存中进行排序，而外部排序因排序的数据量大，内存不能一次容纳全部的排序记录，所以在排序过程中需要访问外存。<br />
![](https://cdn.nlark.com/yuque/0/2020/png/469171/1585224465345-ada21565-de95-468d-afb1-f2cf9cc74001.png#alt=)

经常提及的八大排序算法指的就是内部排序的八种算法，分别是`冒泡排序`、`快速排序`、`直接插入排序`、`希尔排序`、`简单选择排序`、`堆排序`、`归并排序`和`基数排序`。如果按原理划分，`冒泡排序`和`快速排序`都属于**交换排序**，`直接插入排序`和`希尔排序`属于**插入排**序，而`简单选择排序`和`堆排序`属于**选择排序**，如上图所示。

<a name="c352ef93"></a>
## 1.2. Comparison sorts

<a name="f13037fc"></a>
### 1.2.1. Efficiency table

![](https://cdn.nlark.com/yuque/0/2020/png/469171/1585224465582-0cb71611-76ec-45a8-a911-961d2c95b2f1.png#alt=)

<a name="f90f8334"></a>
### 1.2.2 Time complexity

从时间复杂度来说:

1. 平方阶O(n²)排序：各类简单排序：直接插入、直接选择和冒泡排序；
2. 线性对数阶O(nlog₂n)排序：快速排序、堆排序和归并排序；
3. O(n1+§))排序，§是介于0和1之间的常数：希尔排序
4. 线性阶O(n)排序：基数排序(不是基于比较的排序)，此外还有桶、箱排序。

<a name="1704bab8"></a>
### 1.2.3 Time complexity limit

时间复杂度极限:

当被排序的数有一些性质的时候（比如是整数，比如有一定的范围），排序算法的复杂度是可以小于O(nlgn)的。比如：

- 计数排序 复杂度O( k+n) 要求：被排序的数是0~k范围内的整数
- 基数排序 复杂度O( d(k+n) ) 要求：d位数，每个数位有k个取值
- 桶排序 复杂度 O( n ) （平均） 要求：被排序数在某个范围内，并且服从均匀分布

但是，当被排序的数不具有任何性质的时候，**一般使用基于比较的排序算法**，而基于比较的排序算法时间复杂度的下限必须是O( nlgn) 。参考[很多高效排序算法的代价是 nlogn，难道这是排序算法的极限了吗？](https://www.zhihu.com/question/24516934)

**说明**:

1. 当原表有序或基本有序时，直接插入排序和冒泡排序将大大减少比较次数和移动记录的次数，时间复杂度可降至O(n);
2. 而快速排序则相反，当原表基本有序时，将退化为冒泡排序，时间复杂度提高为O（n2）;
3. 原表是否有序，对简单选择排序、堆排序、归并排序和基数排序的时间复杂度影响不大。

<a name="7e440550"></a>
# 2. Bubble Sort

<a name="b20c41be"></a>
## 2.1. Basic theory

[See more at Wiki](https://en.wikipedia.org/wiki/Bubble_sort)

Bubble sort is a simple sorting algorithm. The algorithm starts at the beginning of the data set. It compares the first two elements, and if the first is greater than the second, it swaps them. It continues doing this for each pair of adjacent elements to the end of the data set. It then starts again with the first two elements, repeating until no swaps have occurred on the last pass. This algorithm's average time and worst-case performance is O(n2), so it is rarely used to sort large, unordered data sets. Bubble sort can be used to sort a small number of items (where its asymptotic inefficiency is not a high penalty). Bubble sort can also be used efficiently on a list of any length that is nearly sorted (that is, the elements are not significantly out of place). For example, if any number of elements are out of place by only one position (e.g. 0123546789 and 1032547698), bubble sort's exchange will get them in order on the first pass, the second pass will find all elements in order, so the sort will take only 2n time.

冒泡排序（Bubble Sort）是一种简单的排序算法。它重复访问要排序的数列，一次比较两个元素，如果他们的顺序错误就把他们交换过来。访问数列的工作是重复地进行直到没有再需要交换的数据，也就是说该数列已经排序完成。这个算法的名字由来是因为越小的元素会经由交换慢慢“浮”到数列的顶端，像水中的气泡从水底浮到水面。

<a name="23acca69"></a>
## 1.2. Description

冒泡排序算法的算法过程如下：

1. 比较相邻的元素。如果第一个比第二个大，就交换他们两个。
2. 对每一对相邻元素作同样的工作，从开始第一对到结尾的最后一对。这步做完后，最后的元素会是最大的数。
3. 针对所有的元素重复以上的步骤，除了最后一个。
4. 持续每次对越来越少的元素重复上面的步骤 1~3，直到没有任何一对数字需要比较。

<a name="7b8a53c1"></a>
## 1.3. Implementation

```java
package amos.sort.util;

import java.util.Arrays;

public class BubbleSort {
    public static void bubbleSort1(int[] arr ){
        int k = arr.length;//k为遍历边界
        for (int i = 0; i < k - 1; i++) {
            boolean flag = false;
            for (int j = 0; j < k - 1 - i; j++) {
                if (arr[j] > arr[j + 1]) {
                    int temp = arr[j + 1];
                    arr[j + 1] = arr[j];
                    arr[j] = temp;
                    flag = true;
                }
            }
            if (!flag) break;
        }
    }

    public static void bubbleSort2(int[] arr){
        if (arr.length <= 1) return;
        int i, k= arr.length, temp;
        boolean flag = true;//发生了交换就为true, 没发生就为false，第一次判断时必须标志位true。
        while (flag) {
            flag = false;//每次开始排序前，都设置flag为未排序过
            for (i = 0; i < k - 1; i++) {//前面的数字大于后面的数字就交换
                if (arr[i] > arr[i + 1]) {
                    temp = arr[i + 1];
                    arr[i + 1] = arr[i];
                    arr[i] = temp;
                    //表示交换过数据;
                    flag = true;
                }
            }
            k--;//控制内层循环界限
        }
    }

    public static void main(String[] args) {
        int[] arr = {11, 32, 16, 12, 7, 3, 44, 63, 27};//对0、1个
        System.out.println(Arrays.toString(arr));
        exer(arr);
        System.out.println(Arrays.toString(arr));
    }
}
```

<a name="61a4c71a"></a>
## 1.4. Efficiency

冒泡排序是稳定的排序算法，最容易实现的排序, 最坏的情况是每次都需要交换, 共需遍历并交换将近n²/2次, 时间复杂度为O(n²). 最佳的情况是内循环遍历一次后发现排序是对的, 因此退出循环, 时间复杂度为O(n). 平均来讲, 时间复杂度为O(n²). 由于冒泡排序中只有缓存的temp变量需要内存空间, 因此空间复杂度为常量O(1)。

| 平均时间复杂度 | 最好情况 | 最坏情况 | 空间复杂度 |
| --- | --- | --- | --- |
| O(n^2) | O(n) | O(n^2) | O(1) |


<a name="1f6924d6"></a>
# 3. Quicksort

<a name="916e6d07"></a>
## 3.1. Basic theory

快速排序（Quicksort）是对冒泡排序的一种改进，借用了分治的思想，由C. A. R. Hoare在1962年提出。它的基本思想是：通过一趟排序将要排序的数据分割成独立的两部分，其中一部分的所有数据都比另外一部分的所有数据都要小，然后再按此方法对这两部分数据分别进行快速排序，整个排序过程可以递归进行，以此达到整个数据变成有序序列。

<a name="c7779b9f"></a>
## 3.2. Description

快速排序使用分治策略来把一个序列（list）分为两个子序列（sub-lists）。步骤为：

1. 从数列中挑出一个元素，称为”基准”（pivot）。
2. 重新排序数列，所有比基准值小的元素摆放在基准前面，所有比基准值大的元素摆在基准后面（相同的数可以到任一边）。在这个分区结束之后，该基准就处于数列的中间位置。这个称为分区（partition）操作。
3. 递归地（recursively）把小于基准值元素的子数列和大于基准值元素的子数列排序。
4. 递归到最底部时，数列的大小是零或一，也就是已经排序好了。这个算法一定会结束，因为在每次的迭代（iteration）中，它至少会把一个元素摆到它最后的位置去。

<a name="5216d9bc"></a>
## 3.3. Implementation

```java
package amos.sort.util;

import java.util.Arrays;

public class QuickSort {

    public static void sort(int[] arr, int start, int end){
        if (arr.length <= 1) return;
        if (start >= end) return;

        int left = start;
        int right = end;
        int pivot = arr[left];

        while (left < right) {
            while (left < right && arr[right] >= pivot) right--;
            while (left < right && arr[left] <= pivot) left++;
            if (left < right) swap(arr, left, right);
        }

        swap(arr, start, left);
        sort(arr, start, left-1);
        sort(arr, left+1, end);
    }

    public static void swap(int[] arr, int i, int j){
        int temp = arr[i];
        arr[i] = arr[j];
        arr[j] = temp;
    }

    public static void main(String[] args) {
        int[] arr = {9, -16, 21, 23, -30, -49, 21, 30, 30};
        sort(arr, 0, arr.length-1);
        System.out.println(Arrays.toString(arr));
    }
}
```

<a name="d9728745"></a>
## 3.4. Efficiency

快速排序并不稳定，快速排序每次交换的元素都有可能不是相邻的, 因此它有可能打破原来值为相同的元素之间的顺序。

| 平均时间复杂度 | 最好情况 | 最坏情况 | 空间复杂度 |
| --- | --- | --- | --- |
| O(nlogn) | O(nlogn) | O(n^2) | O(1) |


<a name="4dcad1b8"></a>
# 4. Insertion Sort

<a name="112b20d2"></a>
## 4.1. Basic theory

[See more at wiki](https://en.wikipedia.org/wiki/Insertion_sort)

Insertion sort is a simple sorting algorithm that is relatively efficient for small lists and mostly sorted lists, and is often used as part of more sophisticated algorithms. It works by taking elements from the list one by one and inserting them in their correct position into a new sorted list similar to how we put money in our wallet.[22] In arrays, the new list and the remaining elements can share the array's space, but insertion is expensive, requiring shifting all following elements over by one. Shellsort (see below) is a variant of insertion sort that is more efficient for larger lists.

直接插入排序的基本思想是：将数组中的所有元素依次跟前面已经排好的元素相比较，如果选择的元素比已排序的元素小，则交换，直到全部元素都比较过为止。

<a name="66e79e45"></a>
## 4.2. Description

一般来说，插入排序都采用in-place在数组上实现。具体算法描述如下：

1. 从第一个元素开始，该元素可以认为已经被排序
2. 取出下一个元素，在已经排序的元素序列中从后向前扫描
3. 如果该元素（已排序）大于新元素，将该元素移到下一位置
4. 重复步骤3，直到找到已排序的元素小于或者等于新元素的位置
5. 将新元素插入到该位置后
6. 重复步骤 2~5

<a name="e7352619"></a>
## 4.3. Implementation

```java
package amos.sort.util;

import java.util.Arrays;

public class InsertionSort {
    public static void insertionSort(int[] arr) {
        if (arr.length <= 1) return;
        int i, j, temp;
        for (i = 1; i < arr.length; i++) {
            temp = arr[i];
            j = i - 1;
            while (j >= 0 && arr[j] > temp) {
                arr[j + 1] = arr[j];
                j--;
            }
            arr[j + 1] = temp;
        }
    }

    public static void main(String[] args) {
        int[] arr = {9, -16, 21, 23, -30, -49, 21, 30, 30};
        exer(arr);
        System.out.println(Arrays.toString(arr));
    }
}
```

<a name="98472f81"></a>
## 4.4. Efficiency

直接插入排序是稳定的排序算法。

| 平均时间复杂度 | 最坏时间复杂度 | 空间复杂度 | 是否稳定 |
| --- | --- | --- | --- |
| O(n^2 ) | O(n^2 ) | O(1) | 是 |


<a name="985f0d29"></a>
# 5. Shell Sort

希尔排序，也称递减增量排序算法，1959年Shell发明。是插入排序的一种高速而稳定的改进版本。

希尔排序是先将整个待排序的记录序列分割成为若干子序列分别进行直接插入排序，待整个序列中的记录“基本有序”时，再对全体记录进行依次直接插入排序。

<a name="bb17175a"></a>
## 5.1. Basic theory

将待排序数组按照步长gap进行分组，然后将每组的元素利用直接插入排序的方法进行排序；每次再将gap折半减小，循环上述操作；当gap=1时，利用直接插入，完成排序。

可以看到步长的选择是希尔排序的重要部分。只要最终步长为1任何步长序列都可以工作。一般来说最简单的步长取值是初次取数组长度的一半为增量，之后每次再减半，直到增量为1。更好的步长序列取值可以参考[维基百科](https://zh.wikipedia.org/wiki/%E5%B8%8C%E5%B0%94%E6%8E%92%E5%BA%8F)。

<a name="a9dd740f"></a>
## 5.2. Description

1. 选择一个增量序列t1，t2，…，tk，其中ti>tj，tk=1；（一般初次取数组半长，之后每次再减半，直到增量为1）
2. 按增量序列个数k，对序列进行k 趟排序；
3. 每趟排序，根据对应的增量ti，将待排序列分割成若干长度为 m 的子序列，分别对各子表进行直接插入排序。仅增量因子为 1 时，整个序列作为一个表来处理，表长度即为整个序列的长度。

<a name="114a4b96"></a>
## 5.3. Implementation

```java
public static void shellSort(int[] arr) {
        int d = arr.length / 2;   //设置希尔排序的增量
        while (d >= 1) {
            for (int i = d; i < arr.length; i++) {
                int temp = arr[i];
                int j = i - d;
                while (j >= 0 && arr[j] > temp) {
                    arr[j + d] = arr[j];
                    j -= d;
                }
                arr[j + d] = temp;
            }
            d /= 2;    //缩小增量
        }
    }
```

<a name="d13d5435"></a>
## 5.4. Efficiency

不稳定排序算法，希尔排序第一个突破O(n^2 )的排序算法；是简单插入排序的改进版；它与插入排序的不同之处在于，它会优先比较距离较远的元素，直接插入排序是稳定的；而希尔排序是不稳定的，希尔排序的时间复杂度和步长的选择有关，常用的是 Shell 增量排序，也就是 `N/2` 的序列，Shell 增量序列不是最好的增量序列，其他还有 Hibbard 增量序列、Sedgewick  增量序列等，具体可以参考，[希尔排序增量序列简介](https://blog.csdn.net/Foliciatarier/article/details/53891144)。

从 `N/2` 逐步减半，最原始的那种增量其实这还不算最快的希尔，有几个增量在实践中表现更出色，具体可以看 weiss 的数据结构书，同时里面有希尔排序复杂度的证明，但是涉及组合数学和数论，希尔排序是实现简单但是分析极其困难的一个算法的例子至于楼主问为啥希尔能突破O(n^2 )的界，可以用逆序数来理解：

假设我们要从小到大排序，一个数组中取两个元素如果前面比后面大，则为一个逆序，容易看出排序的本质就是消除逆序数，可以证明对于随机数组，逆序数是O(n^2 )的，而如果采用“交换相邻元素”的办法来消除逆序，每次正好只消除一个，因此必须执行O(n^2 )的交换次数，这就是为啥冒泡、插入等算法只能到平方级别的原因，反过来，基于交换元素的排序要想突破这个下界，必须执行一些比较，交换相隔比较远的元素，使得一次交换能消除一个以上的逆序，希尔、快排、堆排等等算法都是交换比较远的元素，只不过规则各不同罢了。[[1]](#fn1)([https://www.zhihu.com/question/24637339/answer/84079774](https://www.zhihu.com/question/24637339/answer/84079774))

假设从小到大排序，简单起见设数组元素两两不等。现在发现了`a[i]>a[j]`，`i<j`，考虑下标闭区间`[i,j]`这个范围的`j-i+1`个元素，对任意`i<k<j`，考虑`a[k]`：

- 
若`a[k]<a[j]`，交换`a[i]`和`a[j]`后，三者的逆序数从2变为1（例如3 1 2变成2 1 3）

- 
若`a[k]>a[i]`，交换`a[j]`和`a[i]`后，三者的逆序数从2变为1（例如2 3 1变成1 3 2）

- 
若`a[i]>a[k]>a[j]`，交换`a[i]`和`a[j]`后，三者的逆序数从3变为0（例如3 2 1变成1 2 3）


当然，上面每条都重复计算了`a[i]`和`a[j]`的逆序关系，但是减掉重复计算的数量，每次交换，逆序数也必然是递减的，除非你去交换两个本来就有序的元素。

<a name="c36245bb"></a>
# 6. Selection Sort

<a name="6450bff0"></a>
## 6.1. Basic theory

在未排序序列中找到最小（大）元素，存放到未排序序列的起始位置。在所有的完全依靠交换去移动元素的排序方法中，选择排序属于非常好的一种。

<a name="981b88ba"></a>
## 6.2. Description

1. 从待排序序列中，找到关键字最小的元素；
2. 如果最小元素不是待排序序列的第一个元素，将其和第一个元素互换；
3. 从余下的 N - 1 个元素中，找出关键字最小的元素，重复 1~2 步，直到排序结束。

<a name="c5646190"></a>
## 6.3. Implementation

```java
public class SelectSort {
    public static void sort(int[] arr) {
        for (int i = 0; i < arr.length - 1; i++) {
            int min = i;
            for (int j = i+1; j < arr.length; j ++) { //选出之后待排序中值最小的位置
                if (arr[j] < arr[min]) {
                    min = j;
                }
            }
            if (min != i) {
                arr[min] = arr[i] + arr[min];
                arr[i] = arr[min] - arr[i];
                arr[min] = arr[min] - arr[i];
            }
        }
    }
```

<a name="3220d0ab"></a>
## 6.4. Efficiency

不稳定排序算法，选择排序的简单和直观名副其实，这也造就了它出了名的慢性子，无论是哪种情况，哪怕原数组已排序完成，它也将花费将近 `n²/2` 次遍历来确认一遍。 唯一值得高兴的是，它并不耗费额外的内存空间。

| 平均时间复杂度 | 最好情况 | 最坏情况 | 空间复杂度 |
| --- | --- | --- | --- |
| O(n2) | O(n2) | O(n2) | O(1) |


<a name="c470efa1"></a>
# 7. Heapsort

看堆排序之前先介绍一下面几个概念：

**完全二叉树**: 若设二叉树的深度为h, 除第 h 层外, 其它各层(1～h-1)的结点数都达到最大个数, 第 h 层所有的结点都连续集中在最左边, 这就是完全二叉树, 很好理解如下图所示:

<img src="https://strawberryamoszc.oss-cn-shanghai.aliyuncs.com/img/image-20200727194303034.png" alt="image-20200727194303034" style="zoom:50%;" />

**堆**是具有以下性质的完全二叉树, 每个结点的值都大于或等于其左右孩子结点的值, 称为大顶堆; 或者每个结点的值都小于或等于其左右孩子结点的值, 称为小顶堆. 如下图:

![image-20200727194333555](https://strawberryamoszc.oss-cn-shanghai.aliyuncs.com/img/image-20200727194333555.png)

同时, 我们对堆中的结点按层进行编号, 将这种逻辑结构映射到数组中就是下面这个样子:<br />
![](https://cdn.nlark.com/yuque/0/2020/png/469171/1586075374269-49c6b42d-3975-4ff8-aec8-972b92222265.png#alt=)<br />
该数组从逻辑上讲就是一个堆结构, 我们用简单的公式来描述一下堆的定义就是:

大顶堆: `arr[i] >= arr[2i+1] && arr[i] >= arr[2i+2]`<br />
小顶堆: `arr[i] <= arr[2i+1] && arr[i] <= arr[2i+2]`

<a name="7a6a935d"></a>
## 7.1. Basic theory

堆排序的基本思想是：将待排序序列构造成一个**大顶堆**，此时，整个序列的最大值就是堆顶的根节点。将其与末尾元素进行交换，此时末尾就为最大值。然后将剩余 n-1 个元素重新构造成一个**大顶堆**，这样会得到 n 个元素的次大值。如此反复执行，便能得到一个有序序列了。

<a name="6aadf0a1"></a>
## 7.2. Description

① 将无需序列构建成一个堆, 根据升序降序需求选择大顶堆或小顶堆;

② 将堆顶元素与末尾元素交换, 将最大元素"沉"到数组末端;

③ 重新调整结构, 使其满足堆定义, 然后继续交换堆顶元素与当前末尾元素, 反复执行调整+交换步骤, 直到整个序列有序.

<a name="b6a6f0cd"></a>
## 7.3. Implementation

```java
import java.util.Arrays;

public class HeapSort {

    public static void swap(int[] arr, int i, int j){
        int temp = arr[i];
        arr[i] = arr[j];
        arr[j] = temp;
    }

    public static void heapify(int[] arr, int n, int i){
        int max = i;
        int c1 = 2 * i + 1;
        int c2 = 2 * i + 2;
        if (c1 < n && arr[c1] > arr[max]) max = c1;
        if (c2 < n && arr[c2] > arr[max]) max = c2;
        if (i != max) {
            swap(arr, i, max);
            heapify(arr, n, max);
        }
    }

    public static void heapSort(int[] arr){
        int n = arr.length;
        for(int i = (n - 1) / 2; i >= 0; i--){
            heapify(arr, n, i);
        }
        for(int i = n - 1; i>= 0; i--){
            swap(arr, 0, i);
            heapify(arr, i, 0);
        }
    }

    public static void main(String[] args) {
        int[] arr = {11, 32, 16, 12, 7, 3, 44, 63, 27};//对0、1个
        System.out.println(Arrays.toString(arr));
        heapSort(arr);
        System.out.println(Arrays.toString(arr));
    }
}
```

<a name="911f5eec"></a>
## 7.4. Efficiency

由于堆排序中初始化堆的过程比较次数较多, 因此它不太适用于小序列。同时由于多次任意下标相互交换位置, 相同元素之间原本相对的顺序被破坏了, 因此, 它是不稳定的排序。

①. 建立堆的过程, 从 `length/2` 一直处理到0, 时间复杂度为O(n);

②. 调整堆的过程是沿着堆的父子节点进行调整, 执行次数为堆的深度, 时间复杂度为 `O(logn)`;

③. 堆排序的过程由n次第②步完成, 时间复杂度为 `O(nlogn)`.

| 平均时间复杂度 | 最好情况 | 最坏情况 | 空间复杂度 |
| --- | --- | --- | --- |
| O(nlogn) | O(nlogn) | O(nlogn) | O(1) |


<a name="4d21c09a"></a>
# 8. Merge Sort

<a name="e2cfe50a"></a>
## 8.1 Basic theory

归并排序算法是将两个（或两个以上）有序表合并成一个新的有序表，即把待排序序列分为若干个子序列，每个子序列是有序的。然后再把有序子序列合并为整体有序序列。

![](https://user-gold-cdn.xitu.io/2018/9/10/165c2d849cf3a4b6?imageslim#alt=%E5%8E%9F%E7%90%86%E6%BC%94%E7%A4%BA)

<a name="70b1cb52"></a>
## 8.2 Description

采用递归法：

1. 将序列每相邻两个数字进行归并操作，形成 floor(n/2)个序列，排序后每个序列包含两个元素；
2. 将上述序列再次归并，形成 floor(n/4)个序列，每个序列包含四个元素；
3. 重复步骤 2，直到所有元素排序完毕

<a name="d0f9f137"></a>
## 8.3 Implementation

```java
package amos.sort.util;

import java.util.Arrays;

public class MergeSort {

    public static void merge(int[] arr, int l, int m, int r){
        //0 1 2 3 4 5 6 7
        //l       m     r
        int leftLength = m - l;
        int rightLenght = r - m + 1;
        int[] arrLeft = new int[leftLength];
        int[] arrRight = new int[rightLenght];

        for (int i = l; i < m; i++) arrLeft[i - l] = arr[i];
        for (int i = m; i <= r; i++) arrRight[i - m] = arr[i];

        int i=0,j=0,k=l;
        while (i < leftLength && j < rightLenght){
            if (arrLeft[i] <= arrRight[j]){
                arr[k++] = arrLeft[i++];
            }else {
                arr[k++] = arrRight[j++];
            }
        }
        while (i < leftLength) arr[k++] = arrLeft[i++];
        while (j < rightLenght) arr[k++] = arrRight[j++];
    }

    private static void mergeSort(int[] arr, int l, int r) {
        if (l == r) return;
        //0 1 2 3 4 5 6 7
        //l       m     r
        int m = (r+l)/2 + 1;
        mergeSort(arr, l, m-1);
        mergeSort(arr, m, r);
        merge(arr, l, m, r);
    }

    public static void main(String[] args) {
        int[] arr = {11, 32, 16, 12, 7, 3, 44, 63, 27};//
        System.out.println(Arrays.toString(arr));
        mergeSort(arr, 0, 8);
        System.out.println(Arrays.toString(arr));
    }
}
```

<a name="9021a516"></a>
## 8.4 Efficiency

稳定排序算法，从效率上看，归并排序可算是排序算法中的”佼佼者”. 假设数组长度为 `n`，那么拆分数组共需`logn`, 又每步都是一个普通的合并子数组的过程，时间复杂度为 `O(n)`， 故其综合时间复杂度为 `O(nlogn)`。另一方面， 归并排序多次递归过程中拆分的子数组需要保存在内存空间， 其空间复杂度为 `O(n)`。和选择排序一样，归并排序的性能不受输入数据的影响，但表现比选择排序好的多，因为始终都是 `O(nlogn)`的时间复杂度。代价是需要额外的内存空间。

| 平均时间复杂度 | 最好情况 | 最坏情况 | 空间复杂度 |
| --- | --- | --- | --- |
| O(nlogn) | O(nlogn) | O(nlogn) | O(n) |


<a name="2ddd22b5"></a>
# 9. Radix Sort

<a name="009e8675"></a>
## 9.1 Basic theory

将所有待比较数值(正整数)统一为同样的数位长度, 数位较短的数前面补零. 然后, 从最低位开始, 依次进行一次排序. 这样从最低位排序一直到最高位排序完成以后, 数列就变成一个有序序列.

基数排序按照优先从高位或低位来排序有两种实现方案:

**MSD**(Most significant digital) 从最左侧高位开始进行排序. 先按 k1 排序分组, 同一组中记录, 关键码 k1 相等, 再对各组按 k2 排序分成子组, 之后对后面的关键码继续这样的排序分组, 直到按最次位关键码kd对各子组排序后. 再将各组连接起来, 便得到一个有序序列。**MSD 方式适用于位数多的序列.**

**LSD**(Least significant digital) 从最右侧低位开始进行排序. 先从 kd 开始排序, 再对 kd-1 进行排序, 依次重复, 直到对 k1 排序后便得到一个有序序列. **LSD 方式适用于位数少的序列.**

下图是 LSD 基数排序的示意图:<br />
![](https://cdn.nlark.com/yuque/0/2020/gif/469171/1586075374456-056f1473-0de1-4668-86d0-2148d6473608.gif#alt=)

<a name="902abf33"></a>
## 9.2 Description

以 LSD 为例, 从最低位开始, 具体算法描述如下:

① 取得数组中的最大数, 并取得位数;<br />
② `arr` 为原始数组, 从最低位开始取每个位组成 radix 数组;<br />
③ 对 radix 进行计数排序 (利用计数排序适用于小范围数的特点).

<a name="42b6ed0a"></a>
## 9.3 Implementation

基数排序: 通过序列中各个元素的值, 对排序的 N 个元素进行若干趟的"分配"与"收集"来实现排序.

分配: 我们将 `L[i]` 中的元素取出, 首先确定其个位上的数字, 根据该数字分配到与之序号相同的桶中.

收集: 当序列中所有的元素都分配到对应的桶中, 再按照顺序依次将桶中的元素收集形成新的一个待排序列`L[]`. 对新形成的序列 `L[]` 重复执行"分配"和"收集"元素中的十位, 百位…直到分配完该序列中的最高位, 则排序结束.

```java
if (a.length <= 1) {return;}
// 找出待排序数组最大值
int max = a[0];
for (int i = 0; i <a.length; i++) {
    if (a[i] > max) {
        max = a[i];
    }
}
System.out.println("max, " + max);

// 计算出最大数的位数
int maxDigit = 0;
while (max != 0) {
    max = max / 10;
    maxDigit++;
}
System.out.println("maxDigit, " + maxDigit);

int[][] buckets = new int[10][a.length];
int base = 10;

//从低位到高位，对每一位遍历，将所有元素分配到桶中
for (int i = 0; i < maxDigit; i++) {
    //存储各个桶中存储元素的数量
    int[] bucketLen = new int[10];

    //分配: 针对每一位, 将每一位相同的数放进同一个桶中
    for (int j = 0; j < a.length; j++) {
        int whichBucket = (a[j] % base) / (base / 10);
        buckets[whichBucket][bucketLen[whichBucket]] = a[j];
        bucketLen[whichBucket]++;
    }

    int k = 0;
    //收集：将不同桶里数据挨个捞出来,为下一轮高位排序做准备,由于靠近桶底的元素排名靠前,因此从桶底先捞
    for (int l = 0; l < buckets.length; l++) {
        for (int m = 0; m < bucketLen[l]; m++) {
            a[k++] = buckets[l][m];
        }
    }
    System.out.println("Sorting: " + Arrays.toString(a));
    base *= 10;
}
```

<a name="a9dec6a9"></a>
## 9.4 Efficiency

基数排序不改变相同元素之间的相对顺序，因此它是稳定的排序算法，以下是基数排序算法复杂度：

| 平均时间复杂度 | 最好情况 | 最坏情况 | 空间复杂度 |
| --- | --- | --- | --- |
| O(d*(n+r)) | O(d*(n+r)) | O(d*(n+r)) | O(n+r) |


其中, `d` 为位数, `r` 为基数, `n` 为原数组个数. 在基数排序中, 因为没有比较操作, 所以在复杂上, 最好的情况与最坏的情况在时间上是一致的, 均为 O(d*(n + r)).

基数排序更适合用于对时间, 字符串等这些整体权值未知的数据进行排序, 适用于:

1. 数据范围较小, 建议在小于1000;
2. 每个数值都要大于等于0.

基数排序 vs 计数排序 vs 桶排序: 这三种排序算法都利用了桶的概念, 但对桶的使用方法上有明显差异:

基数排序: 根据键值的每位数字来分配桶<br />
计数排序: 每个桶只存储单一键值<br />
桶排序: 每个桶存储一定范围的数值

计数排序和桶排序待补充.

<a name="c39552f1"></a>
# 参考资料

1. [Bilibili-堆排序(heapsort)-正月点灯笼](https://www.bilibili.com/video/BV1Eb41147dK?from=search&seid=831270010059132934)<br />
2. [Bilibili-归并排序(mergesort)-正月点灯笼](https://www.bilibili.com/video/BV1Ax411U7Xx?from=search&seid=3190044538120707935)<br />
3. [面试必备：八种排序算法原理及Java实现-foofoo](https://juejin.im/post/5b95da8a5188255c775d8124)<br />
4. [维基百科](https://en.wikipedia.org/wiki/Sorting_algorithm)<br />
5. [很多高效排序算法的代价是 nlogn，难道这是排序算法的极限了吗？](https://www.zhihu.com/question/24516934)<br />
6. [数学之美番外篇：快排为什么那样快](http://mindhacks.cn/2008/06/13/why-is-quicksort-so-quick/)<br />
7. [准备刷 leetcode 了，才发现自己连时间复杂度都不懂](https://juejin.im/post/5e7c0946f265da42e879fe0c#comment)



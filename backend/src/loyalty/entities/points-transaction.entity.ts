import { Column, CreateDateColumn, Entity, PrimaryGeneratedColumn } from 'typeorm';

@Entity('points_transactions')
export class PointsTransaction {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column()
  userId!: string;

  /** Positive = earn, negative = redeem/debit. */
  @Column({ type: 'int' })
  amount!: number;

  @Column()
  type!: string;

  @Column({ type: 'varchar', nullable: true })
  reference!: string | null;

  @CreateDateColumn()
  createdAt!: Date;
}

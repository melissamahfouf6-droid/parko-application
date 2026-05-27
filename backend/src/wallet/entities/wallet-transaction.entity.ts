import { Column, CreateDateColumn, Entity, PrimaryGeneratedColumn } from 'typeorm';

@Entity('wallet_transactions')
export class WalletTransaction {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ type: 'varchar' })
  userId!: string;

  @Column({ type: 'float' })
  amountKwd!: number;

  @Column({ type: 'varchar' })
  type!: string;

  @Column({ type: 'varchar', nullable: true })
  reference!: string | null;

  @Column({ type: 'varchar', nullable: true })
  description!: string | null;

  @CreateDateColumn()
  createdAt!: Date;
}
